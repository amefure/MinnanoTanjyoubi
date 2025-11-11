//
//  DownSideView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/15.
//

import SwiftUI

struct DownSideView: View {
    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isiPadSize = DeviceSizeUtility.isiPadSize
    private let isSESize = DeviceSizeUtility.isSESize

    let parentFunction: () -> Void
    /// System Image Name
    let imageString: String
    /// Color Scheme
    let scheme: AppColorScheme

    private var viewSize: CGFloat { isSESize ? 35 : 50 }

    var body: some View {
        HStack {
            Rectangle()
                .foregroundColor(scheme.foundationPrimary)
                .frame(width: isiPadSize ? deviceWidth * 0.6 : deviceWidth * 0.8, height: viewSize)
                .cornerRadius(50)
                .offset(x: isiPadSize ? -110 : -30)

            Button {
                parentFunction()
            } label: {
                Image(systemName: imageString)
                    .foregroundColor(scheme.text)
                    .font(isSESize ? .system(size: 12) : .system(size: 17))

            }.frame(width: viewSize, height: viewSize)
                .background(scheme.foundationPrimary)
                .cornerRadius(50)
                .shadow(color: .gray, radius: 3, x: 4, y: 4)

            Spacer()

        }.padding([.top, .bottom])
    }
}
