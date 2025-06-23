//
//  BiometricAuthRepository.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

/// CombineではSwift6対応(Sendable準拠))がされていないため`@preconcurrency`で制限を緩くする
@preconcurrency import Combine
import LocalAuthentication

final class BiometricAuthRepository: Sendable {
    /// ログイン可否
    public var isLogin: AnyPublisher<Bool, Never> {
        _isLogin.eraseToAnyPublisher()
    }

    /// Mutation：ログイン可否
    private let _isLogin = PassthroughSubject<Bool, Never>()

    /// サポートしている生体認証Type
    public var biometryType: AnyPublisher<LABiometryType, Never> {
        _biometryType.eraseToAnyPublisher()
    }

    /// Mutation：サポートしている生体認証Type
    private let _biometryType = PassthroughSubject<LABiometryType, Never>()

    /// LAContext はインスタンスごとに使い捨て
    private func makeNewContext() -> LAContext {
        let context = LAContext()
        context.localizedCancelTitle = "キャンセル"
        return context
    }

    /// 生体認証リクエスト
    public func requestBiometrics() async -> Bool {
        // コンテキストは都度リセットしないと何度も認証なしでログインできてしまう
        let context = makeNewContext()

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            AppLogger.logger.debug("生体認証をサポートしていないデバイスです：\(error)")
            return false
        }
        _biometryType.send(context.biometryType)

        do {
            try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: checkBioTypeMsg(for: context))
            _isLogin.send(true)
            return true
        } catch {
            AppLogger.logger.debug("\(error)")
            return false
        }
    }

    /// ログアウト
    public func logout() {
        _isLogin.send(false)
    }

    /// none と default は呼ばれることはないはず
    /// localizedReason メッセージ
    private func checkBioTypeMsg(for context: LAContext) -> String {
        switch context.biometryType {
        case .none:
            return "サポートされていません。"
        case .faceID:
            return "顔認証を利用してアプリにログインできます。"
        case .touchID:
            return "指紋認証を利用してアプリにログインできます。"
        case .opticID:
            return "虹彩認証を利用してアプリにログインできます。"
        @unknown default:
            return "サポートされていません。"
        }
    }
}
