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
    var user: User
    @State private var isShowUpdateModalView: Bool = false

    private let deviceWidth = DeviceSizeUtility.deviceWidth
    private let isSESize = DeviceSizeUtility.isSESize

    @StateObject private var viewModel = DetailViewModel()

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Group {
                // Relation/あと何日../名前/ふりがな/生年月日/和暦
                UpSideUserInfoView(user: user)
                    .environmentObject(rootEnvironment)

                ZStack(alignment: .bottom) {
                    // 年齢/星座/干支
                    MiddleUserInfoView(user: user)
                        .environmentObject(rootEnvironment)

                    // 共有ボタン
                    HStack {
                        Spacer()

                        Button {
                            ShareInfoUtillity.shareBirthday([user])
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .fontM()
                        }.padding(.trailing)
                    }
                }

                ZStack(alignment: .topTrailing) {
                    // Memo
                    Text(user.memo)
                        .fontM()
                        .truncationMode(.tail) // 文字溢れを「....」にする
                        .padding()
                        .frame(width: deviceWidth - 40, height: 130, alignment: .topLeading)
                        .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
                        .onTapGesture {
                            viewModel.isShowPopUpMemo = true
                        }.overBorder(
                            radius: 5,
                            color: AppColorScheme.getFoundationPrimary(rootEnvironment.scheme),
                            opacity: 0.4,
                            lineWidth: 2
                        )

                    Image(systemName: "hand.rays")
                        .fontL()
                        .padding(.trailing)
                        .padding(.top, 5)
                }

            }.padding(isSESize ? 5 : 10)

            // 通知トグルビュー
            Toggle("通知", isOn: $viewModel.isNotifyFlag)
                .toggleStyle(
                    SwitchToggleStyle(tint: AppColorScheme.getThema1(rootEnvironment.scheme))
                ).fontM()
                .frame(width: DeviceSizeUtility.deviceWidth - 60)
                .padding(DeviceSizeUtility.isSESize ? 5 : 10)

            // 追加しても更新されないので明示的にidを指定する
            ImageContainerView(
                user: user,
                viewModel: viewModel
            ).id(viewModel.isUpdateImageContainerView)
                .environmentObject(rootEnvironment)

            Spacer()

            DownSideView(parentFunction: {
                isShowUpdateModalView = true
            }, imageString: "square.and.pencil")
                .sheet(isPresented: $isShowUpdateModalView, content: {
                    EntryUserView(user: user, isModal: $isShowUpdateModalView)
                }).environmentObject(rootEnvironment)

            if !isSESize && !rootEnvironment.removeAds {
                AdMobBannerView()
                    .frame(height: 50)
            }

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
            .fontWeight(.bold)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { viewModel.onAppear(user: user) }
            .onDisappear { viewModel.onDisappear() }
            .alert(
                isPresented: $viewModel.isDeleteConfirmAlert,
                title: "お知らせ",
                message: "この画像を削除しますか？",
                positiveButtonTitle: "削除",
                negativeButtonTitle: "キャンセル",
                positiveButtonRole: .destructive,
                positiveAction: {
                    // 画像削除
                    viewModel.deleteImage(user: user)
                }, negativeAction: {
                    viewModel.selectPath = ""
                }
            )
            .alert(
                isPresented: $viewModel.isSaveSuccessAlert,
                title: "お知らせ",
                message: "画像を追加しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    viewModel.updateImageContainerView()
                }
            )
            .alert(
                isPresented: $viewModel.isDeleteSuccessAlert,
                title: "お知らせ",
                message: "画像を削除しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    viewModel.selectPath = ""
                    viewModel.updateImageContainerView()
                }
            )
            .alert(
                isPresented: $viewModel.isImageErrorAlert,
                title: viewModel.imageError?.title ?? "エラー",
                message: viewModel.imageError?.message ?? "予期せぬエラーが発生し、画像の保存に失敗しました。\n時間をあけてから再度お試してください。",
                positiveButtonTitle: "OK"
            ).dialogImagePreviewView(
                isPresented: $viewModel.isImageShowAlert,
                image: viewModel.selectImage
            ).popup(
                isPresented: $viewModel.isShowPopUpMemo,
                title: "MEMO",
                message: user.memo
            )
    }
}
