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
    /// 拡大値
    @State private var scale: CGFloat = 1.0
    /// Viewを表示させる座標値
    @State private var position = CGPoint(x: 0, y: 0)
    /// ドラッグジェスチャー量
    @GestureState private var dragOffset = CGSize.zero
    /// 最小許容スケールサイズ
    private let minScale: CGFloat = 1.0

    private func reset() {
        // 表示前にスケールを元に戻す
        scale = 1.0
        position = CGPoint(x: 0, y: 0)
    }

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
                        .frame(maxWidth: DeviceSizeUtility.deviceWidth - 40)
                        .background(scheme.foundationSub)
                        .shadow(radius: 10)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .scaleEffect(scale)
                        .offset(x: position.x + dragOffset.width, y: position.y + dragOffset.height)
                        .gesture(
                            SimultaneousGesture(
                                MagnificationGesture()
                                    .onChanged { value in
                                        scale = max(value, minScale)
                                    },
                                DragGesture()
                                    // ドラッグジェスチャーの変更を観測
                                    .updating($dragOffset, body: { value, state, _ in
                                        // 拡大していないなら移動を禁止する
                                        guard scale != 1.0 else { return }
                                        // state(GestureState)に移動した値を格納することで変化中も移動する
                                        state = value.translation
                                    })
                                    // ドラッグ終了した際に呼ばれる
                                    .onEnded { value in
                                        // 拡大していないなら移動を禁止する
                                        guard scale != 1.0 else { return }
                                        // 移動が完了した座標を格納して固定
                                        position.x += value.translation.width
                                        position.y += value.translation.height
                                    }
                            )
                        )

                    // 画面一杯にViewを広げる
                }
            }.ignoresSafeArea()
                .onTapGesture {
                    isPresented = false
                }.onAppear {
                    reset()
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
