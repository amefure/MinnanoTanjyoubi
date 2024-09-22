//
//  SelectColorScheme.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/09/22.
//

import SwiftUI

struct SelectColorScheme: View {
    @State private var scheme: AppColorScheme = .original
    @State private var isAlert = false

    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("テーマカラー変更")
                .font(.system(size: 20))
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .fontWeight(.bold)
                .padding(.vertical)

            List {
                ForEach(AppColorScheme.allCases, id: \.self) { scheme in
                    Button {
                        self.scheme = scheme
                    } label: {
                        HStack {
                            Text(scheme.name)
                                .foregroundStyle(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))

                            Spacer()

                            if self.scheme == scheme {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
                            }
                        }
                    }
                }
            }.scrollContentBackground(.hidden)
                .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))

            Spacer()

            DownSideView(parentFunction: {
                UIApplication.shared.closeKeyboard()

                rootEnvironment.registerColorScheme(scheme)
                isAlert = true
            }, imageString: "checkmark")
                .environmentObject(rootEnvironment)

            AdMobBannerView()
                .frame(height: 60)

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .font(.system(size: 17))
            .navigationBarBackButtonHidden()
            .onAppear {
                scheme = rootEnvironment.scheme
            }.dialog(
                isPresented: $isAlert,
                title: "お知らせ",
                message: "テーマカラーを変更しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    dismiss()
                }
            )
    }
}

#Preview {
    SelectColorScheme()
}
