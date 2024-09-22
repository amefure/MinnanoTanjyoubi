//
//  DownSideView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/15.
//

import SwiftUI

struct DownSideView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isiPadSize = DeviceSizeUtility.isiPadSize
    private let isSESize = DeviceSizeUtility.isiPadSize

    // EntryView
    public var parentFunction: () -> Void
    // 表示させたい画像名を受け取る
    public var imageString: String

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
                .foregroundColor(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
                .frame(width: isiPadSize ? deviceWidth * 0.6 : deviceWidth * 0.8, height: viewSize)
                .cornerRadius(50)
                .offset(x: isiPadSize ? -110 : -30)

            Button(action: {
                parentFunction()

            }, label: {
                Image(systemName: imageString)
                    .foregroundColor(AppColorScheme.getText(rootEnvironment.scheme))
                    .font(isSESize ? .system(size: 12) : .system(size: 17))

            }).frame(width: viewSize, height: viewSize)
                .background(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
                .cornerRadius(50)
                .shadow(color: .gray, radius: 3, x: 4, y: 4)

            Spacer()

        }.padding([.top, .bottom])
    }
}
