//
//  ShareButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/02.
//

import SwiftUI

struct ShareButtonView: View {
    
    // MARK: - シェアボタン
    private func shareApp(shareText: String, shareLink: String) {
        let items = [shareText, URL(string: shareLink)!] as [Any]
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
        rootVC?.present(activityVC, animated: true,completion: {})
    }
    
    var body: some View {
        Button(action: {
            shareApp(shareText: "友達の誕生日をメモできるアプリ「みんなの誕生日」を使ってみてね♪", shareLink: "https://apps.apple.com/jp/app/%E3%81%BF%E3%82%93%E3%81%AA%E3%81%AE%E8%AA%95%E7%94%9F%E6%97%A5/id1673431227")
        }) {
            HStack{
                Image(systemName:"star.bubble")
                    .settingIcon()
                Text("「みんなの誕生日」をオススメする")
            }
        }
    }
}

struct ShareButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ShareButtonView()
    }
}
