//
//  ImageContainerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/02/22.
//

import Combine
import SwiftUI
import UIKit

struct ImageContainerView: View {
    @State var user: User
    @StateObject var viewModel: DetailViewModel

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    // 画像ピッカー表示
    @State private var isShowImagePicker: Bool = false

    @State private var image: UIImage?
    @State var images: [String] = []

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(images.enumerated()), id: \.element) { index, path in
                    AsyncImage(url: URL(fileURLWithPath: path)) { image in
                        ZStack {
                            image
                                .resizable()
                                .frame(width: 80, height: 80)
                                .onTapGesture {
                                    viewModel.showPreViewImagePopup(image: image)
                                }.onLongPressGesture {
                                    viewModel.showDeleteConfirmAlert(user: user, index: index)
                                }
                            // 選択中UI表示
                            if viewModel.selectPath == user.imagePaths[safe: index] {
                                Rectangle()
                                    .frame(width: 80, height: 80)
                                    .background(.black)
                                    .opacity(0.4)
                            }
                        }

                    } placeholder: {
                        ProgressView()
                            .frame(width: 80, height: 80)
                    }
                }

                Button {
                    isShowImagePicker = true
                } label: {
                    Image(systemName: "plus")
                        .fontM()
                        .frame(width: 80, height: 80)
                        .overBorder(
                            radius: 5,
                            color: AppColorScheme.getFoundationPrimary(rootEnvironment.scheme),
                            opacity: 0.4,
                            lineWidth: 2
                        )
                }
            }.padding(.horizontal)
        }
        .sheet(isPresented: $isShowImagePicker) {
            ImagePickerDialog(image: $image)
        }.onChange(of: image) { image in
            viewModel.saveImage(user: user, image: image)
        }.onAppear {
            // UI表示時に画像パスを取得する
            for path in user.imagePaths {
                guard let path = viewModel.loadImagePath(name: path) else { continue }
                images.append(path)
            }
        }
    }
}

#Preview {
    ImageContainerView(user: User.demoUsers.first!, viewModel: DetailViewModel())
}
