//
//  FBAnalyticsManager.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/05/03.
//

import FirebaseAnalytics

class FBAnalyticsManager {
    /// `screen_view`イベント計測
    static func loggingScreen(screen: AppSreenClassName) {
        Analytics.logEvent(
            AnalyticsEventScreenView,
            parameters: [
                AnalyticsParameterScreenName: screen.name(),
                AnalyticsParameterScreenClass: screen.rawValue,
            ]
        )
    }

    /// みんなの出産祝い広告タップイベント
    static func loggingTapOiwaiAdsEvent() {
        Analytics.logEvent(
            AppEvent.tapOiwaiAds.rawValue,
            parameters: [
                AnalyticsParameterItemID: "tapOiwaiAds",
                AnalyticsParameterItemName: "みんなの出産祝い広告タップ",
            ]
        )
    }
    
    /// 広告視聴容量追加イベント
    static func loggingAddCapacityEvent() {
        Analytics.logEvent(
            AppEvent.addCapacity.rawValue,
            parameters: [
                AnalyticsParameterItemID: "addCapacity",
                AnalyticsParameterItemName: "容量追加",
            ]
        )
    }

    /// アプリ内テーマーカラー選択イベント
    static func loggingSelectColorEvent(color: AppColorScheme) {
        Analytics.logEvent(
            AppEvent.selectThemaColor.rawValue,
            parameters: [
                AnalyticsParameterItemID: color.rawValue,
                AnalyticsParameterItemName: color.name,
            ]
        )
    }

    /// アプリ内ソート機能選択イベント
    static func loggingSelectSortEvent(sort: AppSortItem) {
        Analytics.logEvent(
            AppEvent.selectSortItem.rawValue,
            parameters: [
                AnalyticsParameterItemID: sort.rawValue,
                AnalyticsParameterItemName: sort.name,
            ]
        )
    }
}

/// 　`screen_view`イベント計測用型
enum AppSreenClassName: String {
    case AppLockScreen
    case InAppPurchaseScreen
    case EditNotifyMessageScreen
    case UpdateRelationScreen
    case ShareUserLinkScreen

    func name() -> String {
        return switch self {
        case .AppLockScreen:
            "アプリロック画面"
        case .InAppPurchaseScreen:
            "アプリ内課金購入画面"
        case .EditNotifyMessageScreen:
            "通知メッセージ編集画面"
        case .UpdateRelationScreen:
            "関係値更新画面"
        case .ShareUserLinkScreen:
            "友達情報共有画面"
        }
    }
}

/// 　`screen_view`イベント計測用型
enum AppEvent: String {
    case selectThemaColor = "select_thema_color"
    case selectSortItem = "select_sort_item"
    case addCapacity = "add_capacity"
    case tapOiwaiAds = "tap_oiwai_ads"
}
