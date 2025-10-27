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

    @Environment(\.rootEnvironment) private var rootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environment(\.rootEnvironment, rootEnvironment)

            Text("テーマカラー変更")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.vertical)

            List {
                ForEach(AppColorScheme.allCases, id: \.self) { scheme in
                    Button {
                        self.scheme = scheme
                    } label: {
                        HStack {
                            ColorSchemePreView(
                                color1: scheme.foundationPrimary,
                                color2: scheme.thema2,
                                color3: scheme.thema3,
                                color4: scheme.thema4
                            )

                            Text(scheme.name)
                                .foregroundStyle(Asset.Colors.exText.swiftUIColor)
                                .fontM(bold: true)

                            Spacer()

                            if self.scheme == scheme {
                                Image(systemName: "checkmark")
                                    .foregroundStyle(rootEnvironment.state.scheme.foundationPrimary)
                            }
                        }
                    }
                }

                Text("他のテーマカラーも工事中・・・\n希望はレビューから教えてね。")
                    .foregroundStyle(Asset.Colors.exText.swiftUIColor)
                    .fontM()

            }.scrollContentBackground(.hidden)
                .background(rootEnvironment.state.scheme.foundationSub)

            Spacer()

            DownSideView(
                parentFunction: {
                    UIApplication.shared.closeKeyboard()

                    rootEnvironment.registerColorScheme(scheme)

                    isAlert = true

                },
                imageString: "checkmark"
            ).environment(\.rootEnvironment, rootEnvironment)

        }.background(rootEnvironment.state.scheme.foundationSub)
            .fontM()
            .navigationBarBackButtonHidden()
            .onAppear {
                scheme = rootEnvironment.state.scheme
            }.alert(
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

private struct ColorSchemePreView: View {
    var color1: Color
    var color2: Color
    var color3: Color
    var color4: Color

    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(color1)
                .frame(width: 20, height: 30)
            Rectangle()
                .fill(color2)
                .frame(width: 20, height: 30)
            Rectangle()
                .fill(color3)
                .frame(width: 20, height: 30)
            Rectangle()
                .fill(color4)
                .frame(width: 20, height: 30)
        }
    }
}

#Preview {
    SelectColorScheme()
        .environment(\.rootEnvironment, DIContainer.shared.resolve(RootEnvironment.self))
}
