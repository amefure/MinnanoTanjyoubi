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

/// アプリ内で共通で利用される状態や環境値を保持する
@MainActor
class RootEnvironment: ObservableObject {
    /// `Singleton`
    static let shared = RootEnvironment()

    /// `Property`
    /// カラースキーム
    @Published private(set) var scheme: AppColorScheme = .original
    /// アプリロック
    @Published var appLocked: Bool = false
    /// 広告削除購入フラグ
    @Published var removeAds: Bool = false
    /// 容量解放購入フラグ
    @Published var unlockStorage: Bool = false
    /// 削除対象のUser
    @Published var deleteArray: [User] = []
    /// Deleteモード
    @Published private(set) var isDeleteMode: Bool = false
    /// 関係の名称
    @Published private(set) var relationNameList: [String] = []
    /// レイアウトフラグ表示
    @Published private(set) var sectionLayoutFlag: LayoutItem = .grid

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

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.realmRepository
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        keyChainRepository = repositoryDependency.keyChainRepository
        inAppPurchaseRepository = repositoryDependency.inAppPurchaseRepository

        // UserDefaultsに保存されているフラグを反映
        setUpUserDefaultsFlag()

        // 購入済み課金アイテム観測
        inAppPurchaseRepository.purchasedProducts
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                guard let self else { return }
                // 購入済みアイテム配列が変化した際に購入済みかどうか確認
                let removeAds = inAppPurchaseRepository.isPurchased(ProductItem.removeAds.id)
                let unlockStorage = inAppPurchaseRepository.isPurchased(ProductItem.unlockStorage.id)
                // 両者trueなら更新
                if removeAds { self.removeAds = true }
                if unlockStorage { self.unlockStorage = true }
            }.store(in: &cancellables)
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
    func onAppear() {
        // アプリ起動回数カウント
        setLaunchAppCount()

        // Remoto Config　レビューポップアップ表示バージョン
        // initで呼ぶとdidFinishLaunchingWithOptionsより先に実行されてしまい
        // FirebaseApp.configure()前の呼び出しエラーになってしまうため
        AppManager.sharedRemoteConfigManager.showReviewPopupVersion
            .receive(on: DispatchQueue.main)
            .sink { [weak self] version in
                guard let self else { return }
                // Versionが初期値(0)なら流さない
                if version != 0 {
                    // レビューポップアップ表示マイグレーション
                    resetShowPopUp(version)
                }

            }.store(in: &cancellables)

        // レビューポップアップ表示
        showReviewPopup()
    }
}

// プロパティ操作
extension RootEnvironment {
    /// Deleteモード有効
    func enableDeleteMode() {
        isDeleteMode = true
    }

    /// Deleteモード無効
    func disableDeleteMode() {
        isDeleteMode = false
    }

    /// 対象のUserを追加
    func appendDeleteArray(_ user: User) {
        deleteArray.append(user)
    }

    /// 対象のUserを削除
    func removeDeleteArray(_ user: User) {
        guard let index = deleteArray.firstIndex(where: { $0.id == user.id }) else { return }
        deleteArray.remove(at: index)
    }

    /// Deleteモードリセット
    func resetDeleteMode() {
        isDeleteMode = false
        deleteArray.removeAll()
    }

    /// レビューポップアップ表示
    func showReviewPopup() {
        // 1度表示していれば表示しない
        guard !getShowReviewPopupFlag() else { return }
        // アプリを5回以上起動していない場合は表示しない
        guard getLaunchAppCount() >= popupShowLaunchCount else { return }
        // 登録されている誕生日情報が30以下なら表示しない
        let count = repository.readAllUsers().count
        guard count >= popupShowUserCount else { return }
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
        guard AppManager.sharedUserDefaultManager.getShowReviewPopupMigrateVersion() <= configVersion else {
            return
        }
        // バージョン+1で更新する
        AppManager.sharedUserDefaultManager.setShowReviewPopupMigrateVersion(configVersion + 1)
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

        relationNameList = results
    }

    func getDisplayDaysLater() -> Bool {
        AppManager.sharedUserDefaultManager.getDisplayDaysLater()
    }

    func getDisplayAgeMonth() -> Bool {
        AppManager.sharedUserDefaultManager.getDisplayAgeMonth()
    }

    private func getDisplaySectionLayout() {
        sectionLayoutFlag = AppManager.sharedUserDefaultManager.getDisplaySectionLayout()
    }

    /// セクショングリッドレイアウト変更フラグ登録
    func switchDisplaySectionLayout() {
        AppManager.sharedUserDefaultManager.setDisplaySectionLayout(sectionLayoutFlag.next)
        getDisplaySectionLayout()
    }

    /// アプリカラースキーム取得
    private func getColorScheme() {
        scheme = AppManager.sharedUserDefaultManager.getColorScheme()
    }

    /// アプリカラースキーム登録
    func registerColorScheme(_ scheme: AppColorScheme) {
        // カスタムイベント計測
        FBAnalyticsManager.loggingSelectColorEvent(color: scheme)
        AppManager.sharedUserDefaultManager.setColorScheme(scheme)
        getColorScheme()
    }

    /// レビューポップアップ表示フラグ取得
    private func getShowReviewPopupFlag() -> Bool {
        AppManager.sharedUserDefaultManager.getShowReviewPopupFlag()
    }

    /// レビューポップアップ表示フラグ登録
    private func registerShowReviewPopupFlag(_ flag: Bool) {
        AppManager.sharedUserDefaultManager.setShowReviewPopupFlag(flag)
    }

    /// アプリ起動回数取得
    private func getLaunchAppCount() -> Int {
        AppManager.sharedUserDefaultManager.getLaunchAppCount()
    }

    /// アプリ起動回数登録
    private func setLaunchAppCount(reset: Bool = false) {
        AppManager.sharedUserDefaultManager.setLaunchAppCount(reset: reset)
    }

    /// アプリ内課金購入状況取得
    private func getPurchasedFlag() {
        removeAds = AppManager.sharedUserDefaultManager.getPurchasedRemoveAds()
        unlockStorage = AppManager.sharedUserDefaultManager.getPurchasedUnlockStorage()
    }

    /// アプリにロックがかけてあるかをチェック
    private func getAppLockFlag() {
        appLocked = keyChainRepository.getData().count == 4
    }
}
