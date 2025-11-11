//
//  ImagePreviewDialog.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/23.
//

import SwiftUI

struct ImagePreviewDialog: View {
    @Binding var isPresented: Bool
    let image: Image?
    let scheme: AppColorScheme

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
                        .background(scheme.foundationSub)
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
        scheme: AppColorScheme
    ) -> some View {
        overlay(
            ImagePreviewDialog(isPresented: isPresented, image: image, scheme: scheme)
        )
    }
}

#Preview {
    ImagePreviewDialog(isPresented: Binding.constant(true), image: Image(systemName: "iphone"), scheme: .original)
}
