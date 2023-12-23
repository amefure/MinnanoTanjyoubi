//
//  BiometricAuthManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/23.
//

import Combine
import LocalAuthentication

class BiometricAuthRepository {
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

    /// コンテキスト
    private var context: LAContext = .init()

    /// 生体認証リクエスト
    public func requestBiometrics(completion: @escaping (Bool) -> Void) {
        // コンテキストは都度リセットしないと何度も認証なしでログインできてしまう
        context = LAContext()

        var error: NSError?
        guard context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) else {
            print(error?.localizedDescription ?? "生体認証をサポートしていないデバイスです")
            completion(false)
            return
        }
        _biometryType.send(context.biometryType)
        context.localizedCancelTitle = "キャンセル"

        Task {
            do {
                try await context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: checkBioTypeMsg)
                _isLogin.send(true)
                completion(true)
            } catch {
                print(error.localizedDescription)
                completion(false)
            }
        }
    }

    /// ログアウト
    public func logout() {
        _isLogin.send(false)
    }

    /// localizedReason用のテキストを返す
    /// none と default は呼ばれることはないはず
    private var checkBioTypeMsg: String {
        return switch context.biometryType {
        case .none:
            "サポートされていません。"
        case .faceID:
            "顔認証を利用してアプリにログインできます。"
        case .touchID:
            "指紋認証を利用してアプリにログインできます。"
        case .opticID:
            "虹彩認証を利用してアプリにログインできます。"
        @unknown default:
            "サポートされていません。"
        }
    }
}
