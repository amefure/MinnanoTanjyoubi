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
    /// Localizable.strings
    ///   MinnanoTanjyoubi
    ///
    ///   Created by t&a on 2024/08/13.
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
