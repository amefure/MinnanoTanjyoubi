//
//  InAppPurchaseView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/23.
//

import StoreKit
import SwiftUI

struct InAppPurchaseView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("通知メッセージ編集")
                .font(.system(size: 20))
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .fontWeight(.bold)
                .padding(.vertical)

            Text("通知プレビュー")
                .font(.system(size: 14))
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .fontWeight(.bold)
                .frame(width: DeviceSizeUtility.deviceWidth - 40, alignment: .leading)

            DownSideView(
                parentFunction: {
                    UIApplication.shared.closeKeyboard()

                }, imageString: "checkmark"
            ).environmentObject(rootEnvironment)

        }.onAppear {}.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .ignoresSafeArea(.keyboard)
            .fontM()
            .navigationBarBackButtonHidden()
    }
}

private struct IAPView: View {
    var body: some View {
        if #available(iOS 17.0, *) {
            ProductView(id: "remove_ads")
                .productViewStyle(.large)
                .onInAppPurchaseCompletion { _, result in
                    if case .success(.success(_)) = result {
                        // 課金が成功した場合の処理
                    } else {
                        // 課金が失敗した場合の処理
                    }
                }
        } else {
            // Fallback on earlier versions
        }
    }
}

#Preview {
    InAppPurchaseView()
        .environmentObject(RootEnvironment())
}
