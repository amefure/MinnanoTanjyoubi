// swiftlint:disable all
// Generated using SwiftGen — https://github.com/SwiftGen/SwiftGen

import Foundation

// swiftlint:disable superfluous_disable_command file_length implicit_return prefer_self_in_static_references

// MARK: - Strings

// swiftlint:disable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:disable nesting type_body_length type_name vertical_whitespace_opening_braces
enum L10n {
    /// 通知が届かない場合は、このアプリに対して通知が許可されていない可能性があります。
    /// 端末の設定アプリから「アプリ」＞「みんなの誕生日」＞「通知」から「通知を許可」がONになっていることを確認してください。
    static let howToUseQ1Text = L10n.tr("Localizable", "how_to_use_q1_text", fallback: "通知が届かない場合は、このアプリに対して通知が許可されていない可能性があります。\n端末の設定アプリから「アプリ」＞「みんなの誕生日」＞「通知」から「通知を許可」がONになっていることを確認してください。")
    /// 通知が届かないのですがなぜですか？
    static let howToUseQ1Title = L10n.tr("Localizable", "how_to_use_q1_title", fallback: "通知が届かないのですがなぜですか？")
    /// 通知設定の変更内容は設定を変更後に通知登録した通知に反映されます。
    /// 既にONになっている場合はお手数ですがON→OFF→ONと操作してください。
    static let howToUseQ2Text = L10n.tr("Localizable", "how_to_use_q2_text", fallback: "通知設定の変更内容は設定を変更後に通知登録した通知に反映されます。\n既にONになっている場合はお手数ですがON→OFF→ONと操作してください。")
    /// 通知時間やメッセージを変更したのに反映されません。
    static let howToUseQ2Title = L10n.tr("Localizable", "how_to_use_q2_title", fallback: "通知時間やメッセージを変更したのに反映されません。")
    /// 登録できる人数は制限されています。
    /// ですが広告を視聴していただくことで追加することも可能です。
    static let howToUseQ3Text = L10n.tr("Localizable", "how_to_use_q3_text", fallback: "登録できる人数は制限されています。\nですが広告を視聴していただくことで追加することも可能です。")
    /// 登録できる人数は何人ですか？
    static let howToUseQ3Title = L10n.tr("Localizable", "how_to_use_q3_title", fallback: "登録できる人数は何人ですか？")
    /// 共有されたリンクをクリックしてもアプリが起動しない場合はアプリが最新であることを確認した上で、リンクをコピー後、「Safari」を立ち上げて検索欄長押しして「ペーストして開く」を実行してみてください。
    ///
    /// また複数の誕生日情報を一度に送信した場合にうまく動作しない場合はお手数ですが1つずつ共有してください。
    static let howToUseQ4Text = L10n.tr("Localizable", "how_to_use_q4_text", fallback: "共有されたリンクをクリックしてもアプリが起動しない場合はアプリが最新であることを確認した上で、リンクをコピー後、「Safari」を立ち上げて検索欄長押しして「ペーストして開く」を実行してみてください。\n\nまた複数の誕生日情報を一度に送信した場合にうまく動作しない場合はお手数ですが1つずつ共有してください。")
    /// 誕生日転送(共有)機能が使えない。
    static let howToUseQ4Title = L10n.tr("Localizable", "how_to_use_q4_title", fallback: "誕生日転送(共有)機能が使えない。")
    /// 誕生日情報の共有機能では「通知のON/OFF」、「登録した画像」が転送できません。
    static let howToUseQ5Text = L10n.tr("Localizable", "how_to_use_q5_text", fallback: "誕生日情報の共有機能では「通知のON/OFF」、「登録した画像」が転送できません。")
    /// 誕生日転送(共有)機能で一部の情報が転送されません。
    static let howToUseQ5Title = L10n.tr("Localizable", "how_to_use_q5_title", fallback: "誕生日転送(共有)機能で一部の情報が転送されません。")
    /// 画像は長押ししていただくことで削除可能です。
    static let howToUseQ6Text = L10n.tr("Localizable", "how_to_use_q6_text", fallback: "画像は長押ししていただくことで削除可能です。")
    /// 画像の削除方法がわからない。
    static let howToUseQ6Title = L10n.tr("Localizable", "how_to_use_q6_title", fallback: "画像の削除方法がわからない。")
    /// アプリのレビューもしくは「利用規約」のWebサイトのお問い合わせフォームからフィードバックをいただけるとできる限り対処いたします。
    /// しかしご要望に添えない可能性があることをご了承ください。
    static let howToUseQ7Text = L10n.tr("Localizable", "how_to_use_q7_text", fallback: "アプリのレビューもしくは「利用規約」のWebサイトのお問い合わせフォームからフィードバックをいただけるとできる限り対処いたします。\nしかしご要望に添えない可能性があることをご了承ください。")
    /// ○○な機能を追加してほしい
    static let howToUseQ7Title = L10n.tr("Localizable", "how_to_use_q7_title", fallback: "○○な機能を追加してほしい")
    /// テーマカラーを変更する
    static let settingSectionAppColor = L10n.tr("Localizable", "setting_section_app_color", fallback: "テーマカラーを変更する")
    /// ・アプリにパスワードを設定してロックをかけることができます。
    static let settingSectionAppFooter = L10n.tr("Localizable", "setting_section_app_footer", fallback: "・アプリにパスワードを設定してロックをかけることができます。")
    /// アプリ設定
    static let settingSectionAppHeader = L10n.tr("Localizable", "setting_section_app_header", fallback: "アプリ設定")
    /// 週始まりを変更する
    static let settingSectionAppInitWeek = L10n.tr("Localizable", "setting_section_app_init_week", fallback: "週始まりを変更する")
    /// アプリをロックする
    static let settingSectionAppLock = L10n.tr("Localizable", "setting_section_app_lock", fallback: "アプリをロックする")
    /// 関係名をカスタマイズする
    static let settingSectionAppRelation = L10n.tr("Localizable", "setting_section_app_relation", fallback: "関係名をカスタマイズする")
    /// 誕生日登録・表示設定
    static let settingSectionBirthdayHeader = L10n.tr("Localizable", "setting_section_birthday_header", fallback: "誕生日登録・表示設定")
    /// 登録年数初期値
    static let settingSectionBirthdayMonthCaption = L10n.tr("Localizable", "setting_section_birthday_month_caption", fallback: "登録年数初期値")
    /// 年齢の⚪︎ヶ月を表示する
    static let settingSectionBirthdayMonthTitle = L10n.tr("Localizable", "setting_section_birthday_month_title", fallback: "年齢の⚪︎ヶ月を表示する")
    /// 登録関係初期値
    static let settingSectionBirthdayRelationName = L10n.tr("Localizable", "setting_section_birthday_relation_name", fallback: "登録関係初期値")
    /// 誕生日情報を転送(共有)する
    static let settingSectionBirthdayShare = L10n.tr("Localizable", "setting_section_birthday_share", fallback: "誕生日情報を転送(共有)する")
    /// 並び順を変更する
    static let settingSectionBirthdaySort = L10n.tr("Localizable", "setting_section_birthday_sort", fallback: "並び順を変更する")
    /// 日
    static let settingSectionBirthdayUnitDay = L10n.tr("Localizable", "setting_section_birthday_unit_day", fallback: "日")
    /// 月
    static let settingSectionBirthdayUnitMonth = L10n.tr("Localizable", "setting_section_birthday_unit_month", fallback: "月")
    /// 誕生日までの単位を切り替える
    static let settingSectionBirthdayUnitTitle = L10n.tr("Localizable", "setting_section_birthday_unit_title", fallback: "誕生日までの単位を切り替える")
    /// アプリの不具合はこちら
    static let settingSectionLinkContact = L10n.tr("Localizable", "setting_section_link_contact", fallback: "アプリの不具合はこちら")
    /// よくある質問
    static let settingSectionLinkFaq = L10n.tr("Localizable", "setting_section_link_faq", fallback: "よくある質問")
    /// ・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。
    static let settingSectionLinkFooter = L10n.tr("Localizable", "setting_section_link_footer", fallback: "・アプリに不具合がございましたら「アプリの不具合はこちら」よりお問い合わせください。")
    /// Link
    static let settingSectionLinkHeader = L10n.tr("Localizable", "setting_section_link_header", fallback: "Link")
    /// 広告削除 & 容量解放
    static let settingSectionLinkInAppPurchase = L10n.tr("Localizable", "setting_section_link_in_app_purchase", fallback: "広告削除 & 容量解放")
    /// 「みんなの誕生日」をオススメする
    static let settingSectionLinkRecommend = L10n.tr("Localizable", "setting_section_link_recommend", fallback: "「みんなの誕生日」をオススメする")
    /// アプリをレビューする
    static let settingSectionLinkReview = L10n.tr("Localizable", "setting_section_link_review", fallback: "アプリをレビューする")
    /// 利用規約とプライバシーポリシー
    static let settingSectionLinkTermsOfService = L10n.tr("Localizable", "setting_section_link_terms_of_service", fallback: "利用規約とプライバシーポリシー")
    /// アプリの使い方(チュートリアル)
    static let settingSectionLinkTutorial = L10n.tr("Localizable", "setting_section_link_tutorial", fallback: "アプリの使い方(チュートリアル)")
    /// 通知メッセージを変更する
    static let settingSectionNotifyEditMsgTitle = L10n.tr("Localizable", "setting_section_notify_edit_msg_title", fallback: "通知メッセージを変更する")
    /// ・通知設定を変更した場合はこれより後に通知登録した通知に反映されます。
    /// 既にONになっている場合はON→OFF→ONと操作してください
    static let settingSectionNotifyFooter = L10n.tr("Localizable", "setting_section_notify_footer", fallback: "・通知設定を変更した場合はこれより後に通知登録した通知に反映されます。\n既にONになっている場合はON→OFF→ONと操作してください")
    /// Localizable.strings
    ///   MinnanoTanjyoubi
    ///
    ///   Created by t&a on 2024/08/13.
    static let settingSectionNotifyHeader = L10n.tr("Localizable", "setting_section_notify_header", fallback: "通知設定")
    /// 登録済み通知一覧
    static let settingSectionNotifyListTitle = L10n.tr("Localizable", "setting_section_notify_list_title", fallback: "登録済み通知一覧")
    /// 通知日
    static let settingSectionNotifyTimeCaption = L10n.tr("Localizable", "setting_section_notify_time_caption", fallback: "通知日")
    /// 通知時間
    static let settingSectionNotifyTimeTitle = L10n.tr("Localizable", "setting_section_notify_time_title", fallback: "通知時間")
    /// アプリ容量
    static let settingSectionStorageHeader = L10n.tr("Localizable", "setting_section_storage_header", fallback: "アプリ容量")
    /// 友達の誕生日をメモできるアプリ「みんなの誕生日」を使ってみてね♪
    static let settingShareText = L10n.tr("Localizable", "setting_share_text", fallback: "友達の誕生日をメモできるアプリ「みんなの誕生日」を使ってみてね♪")
    /// このボタンをタップすることで「削除モード」に切り替わります。
    /// 削除したい誕生日情報を選択できるようになるので選んだ後に再度このボタンをタップすることで削除することができます。
    static let tutorialBottomLeftMsg = L10n.tr("Localizable", "tutorial_bottom_left_msg", fallback: "このボタンをタップすることで「削除モード」に切り替わります。\n削除したい誕生日情報を選択できるようになるので選んだ後に再度このボタンをタップすることで削除することができます。")
    /// 誕生日情報を削除できるよ！
    static let tutorialBottomLeftTitle = L10n.tr("Localizable", "tutorial_bottom_left_title", fallback: "誕生日情報を削除できるよ！")
    /// このボタンをタップすることで設定した関係性ごとに誕生日情報をフィルタリングすることができます。
    static let tutorialBottomMiddleMsg = L10n.tr("Localizable", "tutorial_bottom_middle_msg", fallback: "このボタンをタップすることで設定した関係性ごとに誕生日情報をフィルタリングすることができます。")
    /// 誕生日情報をフィルタリング！
    static let tutorialBottomMiddleTitle = L10n.tr("Localizable", "tutorial_bottom_middle_title", fallback: "誕生日情報をフィルタリング！")
    /// このボタンをタップすることで友達や家族の誕生日情報を入力して登録することができます。
    /// 登録した誕生日情報は一覧として表示されるよ。
    static let tutorialBottomRightMsg = L10n.tr("Localizable", "tutorial_bottom_right_msg", fallback: "このボタンをタップすることで友達や家族の誕生日情報を入力して登録することができます。\n登録した誕生日情報は一覧として表示されるよ。")
    /// 誕生日情報を登録をしよう！
    static let tutorialBottomRightTitle = L10n.tr("Localizable", "tutorial_bottom_right_title", fallback: "誕生日情報を登録をしよう！")
    /// NEXT
    static let tutorialNextButton = L10n.tr("Localizable", "tutorial_next_button", fallback: "NEXT")
    /// アプリをはじめよう！
    static let tutorialTopLeftButton = L10n.tr("Localizable", "tutorial_top_left_button", fallback: "アプリをはじめよう！")
    /// 選べる3つのレイアウト
    ///
    /// ・グリッドレイアウト(デフォルト)
    /// ・グリッドレイアウト(セクション分け)
    /// ・カレンダー
    /// 好きなレイアウトでアプリを使ってね。
    static let tutorialTopLeftMsg = L10n.tr("Localizable", "tutorial_top_left_msg", fallback: "選べる3つのレイアウト\n\n・グリッドレイアウト(デフォルト)\n・グリッドレイアウト(セクション分け)\n・カレンダー\n好きなレイアウトでアプリを使ってね。")
    /// レイアウトを変更できるよ！
    static let tutorialTopLeftTitle = L10n.tr("Localizable", "tutorial_top_left_title", fallback: "レイアウトを変更できるよ！")
    /// 通知時間やメッセージ、アプリのロック、テーマカラーの変更、関係性名の変更、容量の追加など自分の好きなようにアプリをカスタマイズすることができます。
    static let tutorialTopRightMsg = L10n.tr("Localizable", "tutorial_top_right_msg", fallback: "通知時間やメッセージ、アプリのロック、テーマカラーの変更、関係性名の変更、容量の追加など自分の好きなようにアプリをカスタマイズすることができます。")
    /// 通知やアプリのカスタマイズ！
    static let tutorialTopRightTitle = L10n.tr("Localizable", "tutorial_top_right_title", fallback: "通知やアプリのカスタマイズ！")
}

// swiftlint:enable explicit_type_interface function_parameter_count identifier_name line_length
// swiftlint:enable nesting type_body_length type_name vertical_whitespace_opening_braces

// MARK: - Implementation Details

extension L10n {
    private static func tr(_ table: String, _ key: String, _ args: CVarArg..., fallback value: String) -> String {
        let format = BundleToken.bundle.localizedString(forKey: key, value: value, table: table)
        return String(format: format, locale: Locale.current, arguments: args)
    }
}

// swiftlint:disable convenience_type
private final class BundleToken {
    static let bundle: Bundle = {
        #if SWIFT_PACKAGE
            return Bundle.module
        #else
            return Bundle(for: BundleToken.self)
        #endif
    }()
}

// swiftlint:enable convenience_type
