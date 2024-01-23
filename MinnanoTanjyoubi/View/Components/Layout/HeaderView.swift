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

    public var isShowSettingIcon: Bool = true

    // MARK: - Setting

    private let deviceWidth = DeviceSizeManager.deviceWidth
    private let isSESize = DeviceSizeManager.isSESize

    var body: some View {
        HStack(alignment: .center) {
            ZStack {
                Image("Appicon-remove")
                    .resizable()
                    .frame(width: isSESize ? 50 : 60, height: isSESize ? 50 : 60)

                if isShowSettingIcon {
                    Button(action: {
                        isSettingActive = true
                    }, label: {
                        Image(systemName: "gearshape.fill")
                    }).foregroundColor(.white).position(x: deviceWidth - 30, y: 30)
                }
            }
        }.frame(width: deviceWidth, height: isSESize ? 60 : 70).background(ColorAsset.foundationColorDark.thisColor)
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
