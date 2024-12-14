//
//  ShareInfoUtillity.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/13.
//
import UIKit

class ShareInfoUtillity {
    /// アプリシェアロジック
    static func shareApp(shareText: String, shareLink: String) {
        guard let url = URL(string: shareLink) else { return }
        let items = [shareText, url] as [Any]
        let activityVC = UIActivityViewController(activityItems: items, applicationActivities: nil)
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popPC = activityVC.popoverPresentationController {
                popPC.sourceView = activityVC.view
                popPC.barButtonItem = .none
                popPC.sourceRect = activityVC.accessibilityFrame
            }
        }
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC = windowScene?.windows.first?.rootViewController
        rootVC?.present(activityVC, animated: true, completion: {})
    }

    /// 誕生日情報を友達に共有するためのリンクを発行しシェアする
    /// - Parameter user: 共有対象の誕生日情報
    static func shareBirthday(_ users: [User]) {
        let jsonConvertUtility = JsonConvertUtility()
        let cryptoUtility = CryptoUtillity()
        guard let json = jsonConvertUtility.convertJson(users) else { return }
        var shareText = "このリンクを開くことで「みんなの誕生日」に受け取った誕生日情報を追加することができます。\nSTEP1：リンクを開く\nSTEP2：「みんなの誕生日」が起動する\nSTEP3：共有された誕生日情報が自動登録\n\n※ リンクをクリックしてもアプリが起動しない場合はリンクをコピー後、「Safari」を立ち上げて検索欄長押しして「ペーストして開く」を実行してみてください。"
        if users.count == 1, let user = users.first {
            shareText = "このリンクを開くことで「みんなの誕生日」に受け取った「\(user.name)」さんの誕生日情報を追加することができます。\nSTEP1：リンクを開く\nSTEP2：「みんなの誕生日」が起動する\nSTEP3：共有された誕生日情報が自動登録\n\n※ リンクをクリックしてもアプリが起動しない場合はリンクをコピー後、「Safari」を立ち上げて検索欄長押しして「ペーストして開く」を実行してみてください。"
        }
        guard let jsonCrypto = cryptoUtility.encryption(json) else { return }
        let shareLink = StaticUrls.CREATE_USER_SCHEME_LINK + jsonCrypto
        shareApp(shareText: shareText, shareLink: shareLink)
    }
}
