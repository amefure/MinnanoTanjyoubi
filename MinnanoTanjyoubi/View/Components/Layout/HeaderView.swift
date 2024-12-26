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

    public var isShowIcon: Bool = true

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
                    }.foregroundColor(AppColorScheme.getText(rootEnvironment.scheme))
                        .position(x: deviceWidth - 30, y: 30)
                }

                if isShowIcon {
                    Button {
                        if rootEnvironment.sectionLayoutFlag {
                            rootEnvironment.registerDisplaySectionLayout(flag: false)
                        } else {
                            rootEnvironment.registerDisplaySectionLayout(flag: true)
                        }
                    } label: {
                        Image(systemName: rootEnvironment.sectionLayoutFlag ? "square.grid.3x3.fill" : "square.grid.3x1.below.line.grid.1x2.fill")
                            .fontM()
                    }.foregroundColor(AppColorScheme.getText(rootEnvironment.scheme))
                        .position(x: 0 + 30, y: 30)
                }
            }
        }.frame(width: deviceWidth, height: isSESize ? 60 : 70)
            .background(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
            .navigationDestination(isPresented: $isSettingActive) {
                SettingView()
                    .environmentObject(rootEnvironment)
            }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
            .environmentObject(RootEnvironment.shared)
    }
}
