//
//  HeaderView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/12.
//

import SwiftUI

struct HeaderView: View {
    // MARK: - Modal Control 設定画面遷移

    @State private var isSettingActive: Bool = false

    public var isShowIcon: Bool = true

    // MARK: - Setting

    private let deviceWidth = DeviceSizeManager.deviceWidth
    private let isSESize = DeviceSizeManager.isSESize

    // MARK: - Environment

    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                Image("Appicon-remove")
                    .resizable()
                    .frame(width: isSESize ? 50 : 60, height: isSESize ? 50 : 60)

                if isShowIcon {
                    Button(action: {
                        isSettingActive = true
                    }, label: {
                        Image(systemName: "gearshape.fill")
                    }).foregroundColor(.white).position(x: deviceWidth - 30, y: 30)
                }

                if isShowIcon {
                    Button(action: {
                        if rootEnvironment.sectionLayoutFlag {
                            rootEnvironment.registerDisplaySectionLayout(flag: false)
                        } else {
                            rootEnvironment.registerDisplaySectionLayout(flag: true)
                        }
                    }, label: {
                        Image(systemName: rootEnvironment.sectionLayoutFlag ? "square.grid.3x3.fill" : "square.grid.3x1.below.line.grid.1x2.fill")
                    }).foregroundColor(.white).position(x: 0 + 30, y: 30)
                }
            }
        }.frame(width: deviceWidth, height: isSESize ? 60 : 70).background(Asset.Colors.foundationColorDark.swiftUIColor)
            .navigationDestination(isPresented: $isSettingActive) {
                SettingView()
            }
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView()
    }
}
