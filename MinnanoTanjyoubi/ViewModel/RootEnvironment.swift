//
//  RootEnvironment.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/12/16.
//

import RealmSwift
import StoreKit
import UIKit

/// アプリ内で共通で利用される状態や環境値を保持する
class RootEnvironment: ObservableObject {
    static let shared = RootEnvironment()

    // カラースキーム
    @Published private(set) var scheme: AppColorScheme = .original
    // 並び順
    @Published private(set) var sort: AppSortItem = .daysLater
    // アプリロック
    @Published var appLocked: Bool = false
    // 削除対象のUserId
    @Published var deleteIdArray: [ObjectId] = []
    // Deleteモード
    @Published private(set) var isDeleteMode: Bool = false
    // 関係の名称
    @Published private(set) var relationNameList: [String] = []
    // レイアウトフラグ表示
    @Published private(set) var sectionLayoutFlag: Bool = false

    private let keyChainRepository: KeyChainRepository
    private let userDefaultsRepository: UserDefaultsRepository
    private let repository = RealmRepository()

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        keyChainRepository = repositoryDependency.keyChainRepository

        getAppLockFlag()
        getColorScheme()
        getSortItem()
        getRelationName()
        getDisplaySectionLayout()
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
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER)
    }

    public func getDisplayAgeMonth() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH)
    }

    private func getDisplaySectionLayout() {
        sectionLayoutFlag = userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_SECTION_LAYOUT)
    }

    /// セクショングリッドレイアウト変更フラグ登録
    public func registerDisplaySectionLayout(flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.DISPLAY_SECTION_LAYOUT, isOn: flag)
        getDisplaySectionLayout()
    }

    private func getColorScheme() {
        let color = userDefaultsRepository.getStringData(key: UserDefaultsKey.APP_COLOR_SCHEME, initialValue: AppColorScheme.original.rawValue)
        scheme = AppColorScheme(rawValue: color) ?? .original
    }

    /// アプリカラースキーム登録
    public func registerColorScheme(_ scheme: AppColorScheme) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.APP_COLOR_SCHEME, value: scheme.rawValue)
        getColorScheme()
    }

    /// 並び順
    private func getSortItem() {
        let item = userDefaultsRepository.getStringData(key: UserDefaultsKey.APP_SORT_ITEM, initialValue: AppSortItem.daysLater.rawValue)
        sort = AppSortItem(rawValue: item) ?? .daysLater
    }

    /// 並び順登録
    public func registerSortItem(_ sort: AppSortItem) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.APP_SORT_ITEM, value: sort.rawValue)
        getSortItem()
    }

    /// レビューポップアップ表示フラグ取得
    private func getShowReviewPopupFlag() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.SHOW_REVIEW_POPUP)
    }

    /// レビューポップアップ表示フラグ登録
    private func registerShowReviewPopupFlag(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.SHOW_REVIEW_POPUP, isOn: flag)
    }

    /// アプリ起動回数取得
    private func getLaunchAppCount() -> Int {
        userDefaultsRepository.getIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT)
    }

    /// アプリ起動回数登録
    private func setLaunchAppCount(reset: Bool = false) {
        if reset {
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT, value: 0)
        } else {
            let addCount = getLaunchAppCount() + 1
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT, value: addCount)
        }
    }

    /// アプリにロックがかけてあるかをチェック
    private func getAppLockFlag() {
        appLocked = keyChainRepository.getData().count == 4
    }
}
