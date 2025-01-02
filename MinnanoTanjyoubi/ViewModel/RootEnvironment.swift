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
class RootEnvironment: ObservableObject {
    /// `Singleton`
    static let shared = RootEnvironment()

    /// `Property`
    /// カラースキーム
    @Published private(set) var scheme: AppColorScheme = .original
    /// 並び順
    @Published private(set) var sort: AppSortItem = .daysLater
    /// アプリロック
    @Published var appLocked: Bool = false
    /// 広告削除購入フラグ
    @Published var removeAds: Bool = false
    /// 容量解放購入フラグ
    @Published var unlockStorage: Bool = false
    /// 削除対象のUserId
    @Published var deleteIdArray: [ObjectId] = []
    /// Deleteモード
    @Published private(set) var isDeleteMode: Bool = false
    /// 関係の名称
    @Published private(set) var relationNameList: [String] = []
    /// レイアウトフラグ表示
    @Published private(set) var sectionLayoutFlag: Bool = false

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
        // `getPurchasedFlag`より後に観測する
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
        getSortItem()
        getRelationName()
        getDisplaySectionLayout()
        getPurchasedFlag()
    }

    public func onAppear() {
        // アプリ起動回数カウント
        setLaunchAppCount()
        // レビューポップアップ表示
        showReviewPopup()
    }
}

// プロパティ操作
extension RootEnvironment {
    /// Deleteモード有効
    public func enableDeleteMode() {
        isDeleteMode = true
    }

    /// Deleteモード無効
    public func disableDeleteMode() {
        isDeleteMode = false
    }

    /// 対象のUserIdを追加
    public func appendDeleteIdArray(id: ObjectId) {
        deleteIdArray.append(id)
    }

    /// 対象のUserIdを削除
    public func removeDeleteIdArray(id: ObjectId) {
        if let index = deleteIdArray.firstIndex(of: id) {
            deleteIdArray.remove(at: index)
        }
    }

    /// Deleteモードリセット
    public func resetDeleteMode() {
        isDeleteMode = false
        deleteIdArray.removeAll()
    }

    /// レビューポップアップ表示
    public func showReviewPopup() {
        // 1度表示していれば表示しない
        guard !getShowReviewPopupFlag() else { return }
        // アプリを5回以上起動していない場合は表示しない
        guard getLaunchAppCount() >= 5 else { return }
        // 登録されている誕生日情報が30以下なら表示しない
        let count = repository.readAllUsers().count
        guard count >= 30 else { return }
        guard let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
        // レビューリクエストポップアップを表示する
        SKStoreReviewController.requestReview(in: scene)
        // iOS18以降：AppStore.requestReview(in: scene)
        registerShowReviewPopupFlag(true)
    }
}

extension RootEnvironment {
    private func setRelationName(key: String, newName: String) {
        userDefaultsRepository.setStringData(key: key, value: newName)
    }

    public func saveRelationName(friend: String, family: String, school: String, work: String, other: String, sns: String) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.DISPLAY_RELATION_FRIEND, value: friend)
        userDefaultsRepository.setStringData(key: UserDefaultsKey.DISPLAY_RELATION_FAMILY, value: family)
        userDefaultsRepository.setStringData(key: UserDefaultsKey.DISPLAY_RELATION_SCHOOL, value: school)
        userDefaultsRepository.setStringData(key: UserDefaultsKey.DISPLAY_RELATION_WORK, value: work)
        userDefaultsRepository.setStringData(key: UserDefaultsKey.DISPLAY_RELATION_OTHER, value: other)
        userDefaultsRepository.setStringData(key: UserDefaultsKey.DISPLAY_RELATION_SNS, value: sns)
        getRelationName()
    }

    public func getRelationName() {
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

    public func getDisplayDaysLater() -> Bool {
        AppManager.sharedUserDefaultManager.getDisplayDaysLater()
    }

    public func getDisplayAgeMonth() -> Bool {
        AppManager.sharedUserDefaultManager.getDisplayAgeMonth()
    }

    private func getDisplaySectionLayout() {
        sectionLayoutFlag = AppManager.sharedUserDefaultManager.getDisplaySectionLayout()
    }

    /// セクショングリッドレイアウト変更フラグ登録
    public func registerDisplaySectionLayout(flag: Bool) {
        AppManager.sharedUserDefaultManager.setDisplaySectionLayout(flag)
        getDisplaySectionLayout()
    }

    /// アプリカラースキーム取得
    private func getColorScheme() {
        scheme = AppManager.sharedUserDefaultManager.getColorScheme()
    }

    /// アプリカラースキーム登録
    public func registerColorScheme(_ scheme: AppColorScheme) {
        AppManager.sharedUserDefaultManager.setColorScheme(scheme)
        getColorScheme()
    }

    /// 並び順
    private func getSortItem() {
        sort = AppManager.sharedUserDefaultManager.getSortItem()
    }

    /// 並び順登録
    public func registerSortItem(_ sort: AppSortItem) {
        AppManager.sharedUserDefaultManager.setSortItem(sort)
        getSortItem()
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

    /// アプリ起動回数取得
    private func getPurchasedFlag() {
        removeAds = AppManager.sharedUserDefaultManager.getPurchasedRemoveAds()
        unlockStorage = AppManager.sharedUserDefaultManager.getPurchasedUnlockStorage()
    }

    /// アプリにロックがかけてあるかをチェック
    private func getAppLockFlag() {
        appLocked = keyChainRepository.getData().count == 4
    }
}
