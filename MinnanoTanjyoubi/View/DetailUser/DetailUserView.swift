//
//  DetailUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/01.
//

import RealmSwift
import SwiftUI

/// リストページからの詳細ページビュー
struct DetailUserView: View {
    private let imageFileManager = ImageFileManager()

    var user: User

    @State private var isShowUpdateView: Bool = false

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isSESize = DeviceSizeUtility.isSESize

    @ObservedObject private var viewModel = DetailViewModel.shared

    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Group {
                // MARK: - Relation/あと何日../名前/ふりがな/生年月日/和暦

                UpSideUserInfoView(user: user)
                    .environmentObject(rootEnvironment)

                // MARK: - 年齢/星座/干支

                MiddleUserInfoView(user: user)
                    .environmentObject(rootEnvironment)

                // MARK: - Memo

                ScrollView {
                    Text(user.memo)
                        .frame(width: deviceWidth - 40)
                        .font(.system(size: 17))
                }.padding(isSESize ? 5 : 10)
                    .frame(width: deviceWidth - 40)
                    .frame(minHeight: isSESize ? 130 : 180)
                    .frame(maxHeight: isSESize ? 130 : 180)
                    .overBorder(
                        radius: 5,
                        color: AppColorScheme.getFoundationPrimary(rootEnvironment.scheme),
                        opacity: 0.4,
                        lineWidth: 2
                    )

            }.padding(isSESize ? 5 : 10)

            // 通知ビュー
            NotificationButtonView(user: user)
                .environmentObject(rootEnvironment)

            // 追加しても更新されないので明示的にidを指定する
            ImageContainerView(user: user)
                .id(viewModel.isUpdateView)
                .environmentObject(rootEnvironment)

            Spacer()

            DownSideView(parentFunction: {
                isShowUpdateView = true
            }, imageString: "square.and.pencil")
                .sheet(isPresented: $isShowUpdateView, content: {
                    EntryUserView(user: user, isModal: $isShowUpdateView)
                }).environmentObject(rootEnvironment)

            if !isSESize {
                AdMobBannerView()
                    .frame(height: 50)
            }

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
            .fontWeight(.bold)
            .toolbar(.hidden, for: .navigationBar)
            .dialog(
                isPresented: $viewModel.isDeleteConfirmAlert,
                title: "お知らせ",
                message: "この画像を削除しますか？",
                positiveButtonTitle: "削除",
                negativeButtonTitle: "キャンセル",
                positiveAction: {
                    var imagePaths = Array(user.imagePaths)
                    imagePaths.removeAll(where: { $0 == viewModel.selectPath })
                    // ここのエラーは握り潰す
                    _ = imageFileManager.deleteImage(name: viewModel.selectPath).sink(receiveCompletion: { _ in }, receiveValue: { _ in })
                    repository.updateImagePathsUser(id: user.id, imagePathsArray: imagePaths)
                    viewModel.isDeleteSuccessAlert = true
                }, negativeAction: {
                    viewModel.selectPath = ""
                }
            )
            .dialog(
                isPresented: $viewModel.isSaveSuccessAlert,
                title: "お知らせ",
                message: "画像を追加しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    viewModel.updateView()
                }
            )
            .dialog(
                isPresented: $viewModel.isDeleteSuccessAlert,
                title: "お知らせ",
                message: "画像を削除しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    viewModel.selectPath = ""
                    viewModel.updateView()
                }
            )
            .dialog(
                isPresented: $viewModel.isImageErrorAlert,
                title: viewModel.imageError?.title ?? "エラー",
                message: viewModel.imageError?.message ?? "予期せぬエラーが発生し、画像の保存に失敗しました。\n時間をあけてから再度お試してください。",
                positiveButtonTitle: "OK"
            ).dialogImageView(
                isPresented: $viewModel.isImageShowAlert,
                image: viewModel.selectImage
            )
    }
}
