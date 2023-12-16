//
//  DownSideView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/15.
//

import SwiftUI

struct DownSideView: View {
    // MARK: - Setting

    private let deviceWidth = DeviceSizeManager.deviceWidth
    private let isiPadSize = DeviceSizeManager.isiPadSize
    private let isSESize = DeviceSizeManager.isiPadSize

    // MARK: - LINK: EntryView

    public var parentFunction: () -> Void
    // 表示させたい画像名を受け取る
    public var imageString: String

    // MARK: - View

    private var viewSize: CGFloat {
        if isSESize {
            return 35
        } else {
            return 50
        }
    }

    var body: some View {
        HStack {
            Rectangle()
                .foregroundColor(ColorAsset.foundationColorDark.thisColor)
                .frame(width: isiPadSize ? deviceWidth * 0.6 : deviceWidth * 0.8, height: viewSize)
                .cornerRadius(50)
                .offset(x: isiPadSize ? -110 : -30)

            Button(action: {
                parentFunction()

            }, label: {
                Image(systemName: imageString)
                    .foregroundColor(.white)
                    .font(isSESize ? .caption : .none)

            }).frame(width: viewSize, height: viewSize)
                .background(ColorAsset.foundationColorDark.thisColor)
                .cornerRadius(50)
                .shadow(color: .gray, radius: 3, x: 4, y: 4)

            Spacer()

        }.padding([.top, .bottom])
    }
}
