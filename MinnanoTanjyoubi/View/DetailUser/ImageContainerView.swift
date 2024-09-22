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
    private let imageFileManager = ImageFileManager()

    @State var user: User
    @State var image: UIImage? = nil

    @ObservedObject private var viewModel = DetailViewModel.shared
    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @State private var isShowImagePicker: Bool = false // 画像ピッカー表示
    @State private var cancellables: Set<AnyCancellable> = Set()
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
                                    viewModel.selectImage = image
                                    viewModel.isImageShowAlert = true
                                }.onLongPressGesture {
                                    viewModel.selectPath = user.imagePaths[safe: index] ?? ""
                                    viewModel.isDeleteConfirmAlert = true
                                }
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
                        .font(.system(size: 17))
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
            guard let image = image else { return }
            let imgName = UUID().uuidString
            imageFileManager.saveImage(name: imgName, image: image)
                .sink { result in
                    switch result {
                    case .finished:
                        var imagePaths = Array(user.imagePaths)
                        imagePaths.append(imgName)
                        repository.updateImagePathsUser(id: user.id, imagePathsArray: imagePaths)
                        viewModel.isSaveSuccessAlert = true
                    case let .failure(error):
                        viewModel.showImageErrorHandle(error: error)
                        return
                    }
                } receiveValue: { _ in

                }.store(in: &cancellables)
        }.onAppear {
            for path in user.imagePaths {
                if let path = imageFileManager.loadImagePath(name: path) {
                    images.append(path)
                }
            }
        }
    }
}

#Preview {
    ImageContainerView(user: User.demoUsers.first!)
}
