//
//  StaticUrls.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/06/18.
//

import UIKit

class StaticUrls {
    /// アプリURL
    static let APP_URL = "https://apps.apple.com/jp/app/%E3%81%BF%E3%82%93%E3%81%AA%E3%81%AE%E8%AA%95%E7%94%9F%E6%97%A5/id1673431227"
    /// レビュー
    static let APP_REVIEW_URL = APP_URL + "?action=write-review"
    ///  Webサイトルート
    static let APP_WEB_URL = "https://appdev-room.com/"
    /// コンタクト
    static let APP_CONTACT_URL = APP_WEB_URL + "contact"
    /// 利用規約
    static let APP_TERMS_OF_SERVICE_URL = APP_WEB_URL + "app-terms-of-service"

    /// `みんなの出産祝い`アプリURL
    static let APP_OIWAI_URL = "https://apps.apple.com/jp/app/%E3%81%BF%E3%82%93%E3%81%AA%E3%81%AE%E5%87%BA%E7%94%A3%E7%A5%9D%E3%81%84/id6742353345"
}

// Custom URL Scheme
extension StaticUrls {
    /// Scheme
    static let CUSTOM_URL_SCHEME = "minnanotanjyoubi-app://"

    /// 誕生日情報登録パラメータ
    static let PARAM_CREATE_USER = "create"
    /// クエリ接頭辞
    static let QUERY_PREFIX = "?"
    /// 誕生日情報登録クエリ
    static let QUERY_CREATE_USER = "birthday="

    /// 誕生日情報登録リンク
    static let CREATE_USER_SCHEME_LINK = CUSTOM_URL_SCHEME + PARAM_CREATE_USER + QUERY_PREFIX + QUERY_CREATE_USER
}
