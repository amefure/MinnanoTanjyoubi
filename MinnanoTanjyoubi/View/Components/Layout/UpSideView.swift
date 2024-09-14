//
//  UpSideView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/15.
//

import SwiftUI

struct UpSideView: View {
    // MARK: - Modal Control

    @Environment(\.dismiss) var dismiss

    // MARK: - Setting

    private let deviceWidth = DeviceSizeManager.deviceWidth
    private let isiPadSize = DeviceSizeManager.isiPadSize
    private let isSESize = DeviceSizeManager.isiPadSize

    private var viewSize: CGFloat {
        if isSESize {
            return 35
        } else {
            return 50
        }
    }

    var body: some View {
        // MARK: - UpSide

        HStack {
            // MARK: - Input View

            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.uturn.left")
                    .foregroundColor(.white)
                    .font(isSESize ? .system(size: 12) : .system(size: 17))

            }.frame(width: viewSize, height: viewSize)
                .background(Asset.Colors.foundationColorDark.swiftUIColor)
                .cornerRadius(viewSize)
                .shadow(color: .gray, radius: 3, x: 4, y: 4)

            Rectangle()
                .foregroundColor(Asset.Colors.foundationColorDark.swiftUIColor)
                .frame(width: isiPadSize ? deviceWidth * 0.6 : deviceWidth * 0.8, height: viewSize)
                .cornerRadius(50)
                .offset(x: isiPadSize ? 110 : 30)

        }.padding([.top, .bottom])

        // MARK: - UpSide
    }
}

struct UpSideView_Previews: PreviewProvider {
    static var previews: some View {
        UpSideView()
    }
}
