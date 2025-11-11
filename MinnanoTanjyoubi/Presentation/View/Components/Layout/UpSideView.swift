//
//  UpSideView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/15.
//

import SwiftUI

/// 上部に表示するBackView
struct UpSideView: View {
    @Environment(\.dismiss) private var dismiss

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isiPadSize = DeviceSizeUtility.isiPadSize
    private let isSESize = DeviceSizeUtility.isSESize

    private var viewSize: CGFloat { isSESize ? 35 : 50 }

    /// Color Scheme
    let scheme: AppColorScheme

    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.uturn.left")
                    .foregroundColor(scheme.text)
                    .font(isSESize ? .system(size: 12) : .system(size: 17))

            }.frame(width: viewSize, height: viewSize)
                .background(scheme.foundationPrimary)
                .cornerRadius(viewSize)
                .shadow(color: .gray, radius: 3, x: 4, y: 4)

            Rectangle()
                .foregroundColor(scheme.foundationPrimary)
                .frame(width: isiPadSize ? deviceWidth * 0.6 : deviceWidth * 0.8, height: viewSize)
                .cornerRadius(50)
                .offset(x: isiPadSize ? 110 : 30)

        }.padding([.top, .bottom])
    }
}

#Preview {
    UpSideView(scheme: .original)
}
