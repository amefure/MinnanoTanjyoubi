//
//  UpSideView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/15.
//

import SwiftUI

struct UpSideView: View {
    @Environment(\.dismiss) private var dismiss

    @EnvironmentObject private var rootEnvironment: RootEnvironment
    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isiPadSize = DeviceSizeUtility.isiPadSize
    private let isSESize = DeviceSizeUtility.isiPadSize

    private var viewSize: CGFloat {
        if isSESize {
            35
        } else {
            50
        }
    }

    var body: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "arrow.uturn.left")
                    .foregroundColor(rootEnvironment.state.scheme.text)
                    .font(isSESize ? .system(size: 12) : .system(size: 17))

            }.frame(width: viewSize, height: viewSize)
                .background(rootEnvironment.state.scheme.foundationPrimary)
                .cornerRadius(viewSize)
                .shadow(color: .gray, radius: 3, x: 4, y: 4)

            Rectangle()
                .foregroundColor(rootEnvironment.state.scheme.foundationPrimary)
                .frame(width: isiPadSize ? deviceWidth * 0.6 : deviceWidth * 0.8, height: viewSize)
                .cornerRadius(50)
                .offset(x: isiPadSize ? 110 : 30)

        }.padding([.top, .bottom])
    }
}

#Preview {
    UpSideView()
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
