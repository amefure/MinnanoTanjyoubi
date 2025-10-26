//
//  HeaderView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/12.
//

import SwiftUI

struct HeaderView: View {
    /// Modal Control 設定画面遷移
    @State private var isSettingActive: Bool = false

    var isShowIcon: Bool = true

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isSESize = DeviceSizeUtility.isSESize

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                Asset.Images.appiconRemove.swiftUIImage
                    .resizable()
                    .frame(width: isSESize ? 50 : 60, height: isSESize ? 50 : 60)

                if isShowIcon {
                    Button {
                        isSettingActive = true
                    } label: {
                        Image(systemName: "gearshape.fill")
                            .fontM()
                    }.foregroundColor(rootEnvironment.state.scheme.text)
                        .position(x: deviceWidth - 30, y: 30)
                }

                if isShowIcon {
                    Button {
                        rootEnvironment.switchDisplaySectionLayout()
                    } label: {
                        Image(systemName: rootEnvironment.state.sectionLayoutFlag.next.imageName)
                            .fontM()
                    }.foregroundStyle(rootEnvironment.state.scheme.text)
                        .position(x: 0 + 30, y: 30)
                }
            }
        }.frame(width: deviceWidth, height: isSESize ? 60 : 70)
            .background(rootEnvironment.state.scheme.foundationPrimary)
            .navigationDestination(isPresented: $isSettingActive) {
                SettingView()
                    .environmentObject(rootEnvironment)
            }
    }
}

#Preview {
    HeaderView()
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
