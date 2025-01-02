//
//  UserDefaultManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/29.
//

class UserDefaultManager {
    private let userDefaultsRepository: UserDefaultsRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
    }

    /// `DISPLAY_DAYS_LATER`
    /// 取得：後何日かフラグ
    public func getDisplayDaysLater() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER)
    }

    /// 登録：後何日かフラグ
    public func setDisplayDaysLater(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.DISPLAY_DAYS_LATER, isOn: flag)
    }

    /// `DISPLAY_AGE_MONTH`
    /// 取得：年齢に何ヶ月を表示するかどうか
    public func getDisplayAgeMonth() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH)
    }

    /// 取得：年齢に何ヶ月を表示するかどうか
    public func setDisplayAgeMonth(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.DISPLAY_AGE_MONTH, isOn: flag)
    }

    /// `DISPLAY_AGE_MONTH`
    /// 取得：セクショングリッドレイアウト変更フラグ
    public func getDisplaySectionLayout() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.DISPLAY_SECTION_LAYOUT)
    }

    /// 登録：セクショングリッドレイアウト変更フラグ
    public func setDisplaySectionLayout(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.DISPLAY_SECTION_LAYOUT, isOn: flag)
    }

    /// `APP_COLOR_SCHEME`
    /// 取得：アプリカラースキーム
    public func getColorScheme() -> AppColorScheme {
        let color = userDefaultsRepository.getStringData(key: UserDefaultsKey.APP_COLOR_SCHEME, initialValue: AppColorScheme.original.rawValue)
        return AppColorScheme(rawValue: color) ?? .original
    }

    /// 登録：アプリカラースキーム
    public func setColorScheme(_ scheme: AppColorScheme) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.APP_COLOR_SCHEME, value: scheme.rawValue)
    }

    /// `APP_SORT_ITEM`
    /// 取得：並び順
    public func getSortItem() -> AppSortItem {
        let item = userDefaultsRepository.getStringData(key: UserDefaultsKey.APP_SORT_ITEM, initialValue: AppSortItem.daysLater.rawValue)
        return AppSortItem(rawValue: item) ?? .daysLater
    }

    /// 登録：並び順
    public func setSortItem(_ sort: AppSortItem) {
        userDefaultsRepository.setStringData(key: UserDefaultsKey.APP_SORT_ITEM, value: sort.rawValue)
    }

    /// `SHOW_REVIEW_POPUP`
    /// 取得：レビューポップアップ表示フラグ
    public func getShowReviewPopupFlag() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.SHOW_REVIEW_POPUP)
    }

    /// 登録：レビューポップアップ表示フラグ
    public func setShowReviewPopupFlag(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.SHOW_REVIEW_POPUP, isOn: flag)
    }

    /// `LAUNCH_APP_COUNT`
    /// 取得：アプリ起動回数
    public func getLaunchAppCount() -> Int {
        userDefaultsRepository.getIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT)
    }

    /// 登録：アプリ起動回数登録
    public func setLaunchAppCount(reset: Bool = false) {
        if reset {
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT, value: 0)
        } else {
            let addCount = getLaunchAppCount() + 1
            userDefaultsRepository.setIntData(key: UserDefaultsKey.LAUNCH_APP_COUNT, value: addCount)
        }
    }

    /// `PURCHASED_REMOVE_ADS`
    /// 取得：アプリ内課金 / 広告削除
    public func getPurchasedRemoveAds() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS)
    }

    /// 登録：アプリ内課金 / 広告削除
    public func setPurchasedRemoveAds(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.PURCHASED_REMOVE_ADS, isOn: flag)
    }

    /// `PURCHASED_UNLOCK_STORAGE`
    /// 取得：アプリ内課金 / 容量解放
    public func getPurchasedUnlockStorage() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_STORAGE)
    }

    /// 登録：アプリ内課金 / 容量解放
    public func setPurchasedUnlockStorage(_ flag: Bool) {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.PURCHASED_UNLOCK_STORAGE, isOn: flag)
    }
}
