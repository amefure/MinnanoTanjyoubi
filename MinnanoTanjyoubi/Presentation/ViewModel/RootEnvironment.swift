//
//  RootEnvironment.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/16.
//

import Combine
import RealmSwift
import StoreKit
import UIKit

@Observable
final class RootEnvironmentState {
    private(set) var scheme: AppColorScheme = .original
    /// アプリロック
    var appLocked: Bool = false
    /// 広告削除購入フラグ
    var removeAds: Bool = false
    /// 容量解放購入フラグ
    var unlockStorage: Bool = false
    /// 削除対象のUser
    var deleteArray: [User] = []
    /// Deleteモード
    private(set) var isDeleteMode: Bool = false
    /// 関係の名称
    private(set) var relationNameList: [String] = []
    /// レイアウトフラグ表示
    private(set) var sectionLayoutFlag: LayoutItem = .grid

    /// カラースキーム更新
    func updateColorScheme(_ scheme: AppColorScheme) { self.scheme = scheme }

    /// Deleteモード有効
    func enableDeleteMode() { isDeleteMode = true }
    /// Deleteモード無効
    func disableDeleteMode() { isDeleteMode = false }

    /// 関係名称リスト更新
    func updateRelationNameList(_ list: [String]) { relationNameList = list }

    /// レイアウトフラグ更新
    func updateSectionLayoutFlag(_ item: LayoutItem) { sectionLayoutFlag = item }
}

/// アプリ内で共通で利用される状態や環境値を保持する
final class RootEnvironment: ObservableObject {
    var state = RootEnvironmentState()

    /// ポップアップ表示起動回数定数
    private let popupShowLaunchCount: Int = 5
    /// ポップアップ表示登録数定数
    private let popupShowUserCount: Int = 30

    /// `Combine`
    private var cancellables: Set<AnyCancellable> = []

    /// `Repository`
    private let repository: RealmRepository
    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let inAppPurchaseRepository: InAppPurchaseRepository
    private let notificationRequestManager: NotificationRequestManager
    private let remoteConfigManager: RemoteConfigManager

    init(
        repository: RealmRepository,
        userDefaultsRepository: UserDefaultsRepository,
        keyChainRepository: KeyChainRepository,
        inAppPurchaseRepository: InAppPurchaseRepository,
        notificationRequestManager: NotificationRequestManager,
        remoteConfigManager: RemoteConfigManager
    ) {
        self.repository = repository
        self.userDefaultsRepository = userDefaultsRepository
        self.keyChainRepository = keyChainRepository
        self.inAppPurchaseRepository = inAppPurchaseRepository
        self.notificationRequestManager = notificationRequestManager
        self.remoteConfigManager = remoteConfigManager

        // UserDefaultsに保存されているフラグを反映
        // イニシャライザ内で取得しておかないとViewの更新後に変化することになる
        setUpUserDefaultsFlag()
    }

    /// `UserDefaults`に保存されている情報を取得してセットアップ
    private func setUpUserDefaultsFlag() {
        getAppLockFlag()
        getColorScheme()
        getRelationName()
        getDisplaySectionLayout()
        getPurchasedFlag()
    }

    /// アプリ起動時に1回だけ呼ばれる設計
    @MainActor
    func onAppear() {
        Task {
            // 通知の許可申請
            await notificationRequestManager.requestAuthorization()
        }

        // 購入済み課金アイテム観測
        inAppPurchaseRepository.purchasedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                // 購入済みアイテム配列が変化した際に購入済みかどうか確認
                let removeAds = inAppPurchaseRepository.isPurchased(ProductItem.removeAds.id)
                let unlockStorage = inAppPurchaseRepository.isPurchased(ProductItem.unlockStorage.id)
                // 両者trueなら更新
                if removeAds { state.removeAds = true }
                if unlockStorage { state.unlockStorage = true }
            }.store(in: &cancellables)

        // アプリ起動回数カウント
        setLaunchAppCount()

        // Remoto Config　レビューポップアップ表示バージョン
        // initで呼ぶとdidFinishLaunchingWithOptionsより先に実行されてしまい
        // FirebaseApp.configure()前の呼び出しエラーになってしまうため
        remoteConfigManager.showReviewPopupVersion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] version in
                guard let self else { return }
                // Versionが初期値(0)なら流さない
                guard version != 0 else { return }
                // レビューポップアップ表示マイグレーション
                resetShowPopUp(version)

            }.store(in: &cancellables)

        // レビューポップアップ表示
        showReviewPopup()
    }

    /// 課金アイテムの購入状況を確認
    @MainActor
    func listenInAppPurchase() {
        Task {
            // 課金アイテムの変化を観測
            await inAppPurchaseRepository.startListen()
        }
    }
}

// プロパティ操作
extension RootEnvironment {
    /// Deleteモード有効
    func enableDeleteMode() {
        state.enableDeleteMode()
    }

    /// Deleteモード無効
    func disableDeleteMode() {
        state.disableDeleteMode()
    }

    /// 対象のUserを追加
    func appendDeleteArray(_ user: User) {
        state.deleteArray.append(user)
    }

    /// 対象のUserを削除
    func removeDeleteArray(_ user: User) {
        guard let index = state.deleteArray.firstIndex(where: { $0.id == user.id }) else { return }
        state.deleteArray.remove(at: index)
    }

    /// Deleteモードリセット
    func resetDeleteMode() {
        state.disableDeleteMode()
        state.deleteArray.removeAll()
    }

    /// レビューポップアップ表示
    @MainActor
    func showReviewPopup() {
        // 1度表示していれば表示しない
        guard !getShowReviewPopupFlag() else { return }
        // アプリを5回以上起動していない場合は表示しない
        guard getLaunchAppCount() >= popupShowLaunchCount else { return }
        // 登録されている誕生日情報が30以下なら表示しない
        let users: [User] = repository.readAllObjs()
        guard users.count >= popupShowUserCount else { return }
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        // レビューリクエストポップアップを表示する
        SKStoreReviewController.requestReview(in: scene)
        // iOS18以降：AppStore.requestReview(in: scene)
        // 計測
        FBAnalyticsManager.loggingShowReviewPopupEvent()
        registerShowReviewPopupFlag(true)
    }

    /// レビューポップアップ表示マイグレーション
    private func resetShowPopUp(_ configVersion: Int) {
        // バージョンが一致またはRemoto Config以下なら更新する
        // アプリ内 0 : Remoto Config 0 => 更新
        // アプリ内 0 : Remoto Config 1 => 更新
        // アプリ内 2 : Remoto Config 1 => 更新しない
        guard userDefaultsRepository.getShowReviewPopupMigrateVersion() <= configVersion else {
            return
        }
        // バージョン+1で更新する
        userDefaultsRepository.setShowReviewPopupMigrateVersion(configVersion + 1)
        // 表示フラグをリセット
        registerShowReviewPopupFlag(false)
        // アプリ起動回数もリセット
        setLaunchAppCount(reset: true)
        // 次回起動時から回数カウントが始まりレビューポップアップが表示される
    }
}

extension RootEnvironment {
    func getRelationName() {
        var results: [String] = []
        let friend = userDefaultsRepository.getStringData(key: UserDefaultsKey.DISPLAY_RELATION_FRIEND, initialValue: RelationConfig.FRIEND_NAME)
        results.append(friend)
        let famiry = userDefaultsRepository.getStringData(key: UserDefaultsKey.DISPLAY_RELATION_FAMILY, initialValue: RelationConfig.FAMILY_NAME)
        results.append(famiry)
        let school = userDefaultsRepository.getStringData(key: UserDefaultsKey.DISPLAY_RELATION_SCHOOL, initialValue: RelationConfig.SCHOOL_NAME)
        results.append(school)
        let work = userDefaultsRepository.getStringData(key: UserDefaultsKey.DISPLAY_RELATION_WORK, initialValue: RelationConfig.WORK_NAME)
        results.append(work)
        let other = userDefaultsRepository.getStringData(key: UserDefaultsKey.DISPLAY_RELATION_OTHER, initialValue: RelationConfig.OTHER_NAME)
        results.append(other)
        let sns = userDefaultsRepository.getStringData(key: UserDefaultsKey.DISPLAY_RELATION_SNS, initialValue: RelationConfig.SNS_NAME)
        results.append(sns)

        state.updateRelationNameList(results)
    }

    func getDisplayDaysLater() -> Bool {
        userDefaultsRepository.getDisplayDaysLater()
    }

    func getDisplayAgeMonth() -> Bool {
        userDefaultsRepository.getDisplayAgeMonth()
    }

    private func getDisplaySectionLayout() {
        state.updateSectionLayoutFlag(userDefaultsRepository.getDisplaySectionLayout())
    }

    /// セクショングリッドレイアウト変更フラグ登録
    func switchDisplaySectionLayout() {
        userDefaultsRepository.setDisplaySectionLayout(state.sectionLayoutFlag.next)
        getDisplaySectionLayout()
    }

    /// アプリカラースキーム取得
    private func getColorScheme() {
        state.updateColorScheme(userDefaultsRepository.getColorScheme())
    }

    /// アプリカラースキーム登録
    func registerColorScheme(_ scheme: AppColorScheme) {
        // カスタムイベント計測
        FBAnalyticsManager.loggingSelectColorEvent(color: scheme)
        userDefaultsRepository.setColorScheme(scheme)
        getColorScheme()
    }

    /// レビューポップアップ表示フラグ取得
    private func getShowReviewPopupFlag() -> Bool {
        userDefaultsRepository.getShowReviewPopupFlag()
    }

    /// レビューポップアップ表示フラグ登録
    private func registerShowReviewPopupFlag(_ flag: Bool) {
        userDefaultsRepository.setShowReviewPopupFlag(flag)
    }

    /// アプリ起動回数取得
    private func getLaunchAppCount() -> Int {
        userDefaultsRepository.getLaunchAppCount()
    }

    /// アプリ起動回数登録
    private func setLaunchAppCount(reset: Bool = false) {
        userDefaultsRepository.setLaunchAppCount(reset: reset)
    }

    /// アプリ内課金購入状況取得
    private func getPurchasedFlag() {
        state.removeAds = userDefaultsRepository.getPurchasedRemoveAds()
        state.unlockStorage = userDefaultsRepository.getPurchasedUnlockStorage()
    }

    /// アプリにロックがかけてあるかをチェック
    private func getAppLockFlag() {
        state.appLocked = keyChainRepository.getData().count == 4
    }
}
