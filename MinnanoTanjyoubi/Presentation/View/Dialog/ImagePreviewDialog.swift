//
//  ImagePreviewDialog.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/23.
//

import SwiftUI

struct ImagePreviewDialog: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @Binding var isPresented: Bool

    let image: Image?

    var body: some View {
        if isPresented {
            ZStack {
                // 画面全体を覆う黒い背景
                Color.black
                    .opacity(0.3)

                // ダイアログコンテンツ部分
                if let image {
                    image
                        .resizable()
                        .scaledToFit()
                        .padding(5)
                        .frame(maxWidth: 300)
                        .background(rootEnvironment.state.scheme.foundationSub)
                        .shadow(radius: 10)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                    // 画面一杯にViewを広げる
                }
            }.ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }
        }
    }
}

extension View {
    func dialogImagePreviewView(
        isPresented: Binding<Bool>,
        image: Image?,
        environment: RootEnvironment
    ) -> some View {
        overlay(
            ImagePreviewDialog(isPresented: isPresented, image: image)
                .environmentObject(environment)
        )
    }
}

#Preview {
    ImagePreviewDialog(isPresented: Binding.constant(true), image: Image(systemName: "iphone"))
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
