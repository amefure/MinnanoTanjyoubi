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
    var userId: ObjectId

    @StateObject private var viewModel = DIContainer.shared.resolve(DetailUserViewModel.self)

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    private var roundWidth: CGFloat {
        return DeviceSizeUtility.deviceWidth < 400 ? 50 : 65
    }

    private let dfmJp = DateFormatUtility(format: .jp)
    private let dfmJpOnlyDate = DateFormatUtility(format: .jpOnlyDate)
    private let dfmJpEra = DateFormatUtility(format: .jpEra)

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Group {
                // Relation/あと何日../名前/ふりがな/生年月日/和暦
                upSideUserInfoView()

                ZStack(alignment: .bottom) {
                    // 年齢/星座/干支
                    middleUserInfoView()

                    // 共有ボタン
                    HStack {
                        Spacer()

                        Button {
                            ShareInfoUtillity.shareBirthday([viewModel.targetUser])
                        } label: {
                            Image(systemName: "square.and.arrow.up")
                                .fontM()
                        }.padding(.trailing)
                    }
                }

                ZStack(alignment: .topTrailing) {
                    // Memo
                    Text(viewModel.targetUser.memo)
                        .fontM()
                        .truncationMode(.tail) // 文字溢れを「....」にする
                        .padding()
                        .frame(
                            width: DeviceSizeUtility.deviceWidth - 40,
                            height: DeviceSizeUtility.isSESize ? 130 : 200,
                            alignment: .topLeading
                        )
                        .background(rootEnvironment.scheme.foundationSub)
                        .onTapGesture {
                            viewModel.isShowPopUpMemo = true
                        }.overBorder(
                            radius: 5,
                            color: rootEnvironment.scheme.foundationPrimary,
                            opacity: 0.4,
                            lineWidth: 2
                        )

                    Image(systemName: "hand.rays")
                        .fontL()
                        .padding(.trailing)
                        .padding(.top, 5)
                }

            }.padding(DeviceSizeUtility.isSESize ? 5 : 10)

            // 通知トグルビュー
            Toggle("通知", isOn: $viewModel.isNotifyFlag)
                .toggleStyle(
                    SwitchToggleStyle(tint: rootEnvironment.scheme.thema1)
                ).fontM()
                .frame(width: DeviceSizeUtility.deviceWidth - 60)
                .padding(DeviceSizeUtility.isSESize ? 5 : 10)

            // 追加しても更新されないので明示的にidを指定する
            imageContainerView()

            Spacer()

            DownSideView(
                parentFunction: {
                    viewModel.isShowUpdateModalView = true
                },
                imageString: "square.and.pencil"
            ).sheet(isPresented: $viewModel.isShowUpdateModalView) {
                EntryUserView(updateUserId: viewModel.targetUser.id, isSelfShowModal: $viewModel.isShowUpdateModalView)
            }.environmentObject(rootEnvironment)

            if !DeviceSizeUtility.isSESize && !rootEnvironment.removeAds {
                AdMobBannerView()
                    .frame(height: 50)
            }

        }.background(rootEnvironment.scheme.foundationSub)
            .foregroundStyle(rootEnvironment.scheme.text)
            .fontWeight(.bold)
            .toolbar(.hidden, for: .navigationBar)
            .onAppear { viewModel.onAppear(id: userId) }
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
                    viewModel.deleteImage()
                }, negativeAction: {
                    viewModel.selectedDeleteImagePath = ""
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
                    viewModel.selectedDeleteImagePath = ""
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
                image: viewModel.selectedPreViewImage,
                environment: rootEnvironment
            ).popup(
                isPresented: $viewModel.isShowPopUpMemo,
                title: "MEMO",
                message: viewModel.targetUser.memo
            )
    }

    /// Relation/あと何日../名前/ふりがな/生年月日/和暦
    private func upSideUserInfoView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(rootEnvironment.relationNameList[safe: viewModel.targetUser.relation.relationIndex] ?? "その他")
                    .padding(8)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: roundWidth, alignment: .center)
                    .frame(maxWidth: roundWidth * 1.5)
                    .lineLimit(1)
                    .background(rootEnvironment.scheme.foundationPrimary)
                    .cornerRadius(5)
                    .font(DeviceSizeUtility.isSESize ? .system(size: 12) : .system(size: 17))

                Spacer()

                HStack(alignment: .bottom) {
                    let daysLater = UserCalcUtility.daysLater(from: viewModel.targetUser.date)
                    if daysLater == 0 {
                        Text("HAPPY BIRTHDAY")
                            .foregroundStyle(rootEnvironment.scheme.thema1)
                            .fontWeight(.bold)

                    } else {
                        Text("あと")
                        Text("\(daysLater)")
                            .foregroundColor(rootEnvironment.scheme.thema1)
                        Text("日")
                    }

                }.padding(8)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: roundWidth, alignment: .center)
                    .background(rootEnvironment.scheme.foundationPrimary)
                    .cornerRadius(5)
                    .font(DeviceSizeUtility.isSESize ? .system(size: 12) : .system(size: 17))
            }

            Text(viewModel.targetUser.ruby)
                .font(DeviceSizeUtility.isSESize ? .system(size: 12) : .system(size: 14))
            Text(viewModel.targetUser.name)
                .font(DeviceSizeUtility.isSESize ? .system(size: 17) : .system(size: 20))
            HStack {
                if viewModel.targetUser.isYearsUnknown {
                    Text(dfmJpOnlyDate.getString(date: viewModel.targetUser.date))
                    Text("（年数未設定）")
                } else {
                    Text(dfmJp.getString(date: viewModel.targetUser.date))
                    Text("（\(dfmJpEra.getString(date: viewModel.targetUser.date))）")
                }
            }.padding(.top, 8)
                .fontM()
        }
    }

    /// 年齢/星座/干支
    private func middleUserInfoView() -> some View {
        HStack(spacing: 20) {
            VStack {
                if viewModel.targetUser.isYearsUnknown {
                    Text("- 歳")
                } else {
                    Text("\(UserCalcUtility.currentAge(from: viewModel.targetUser.date))歳")
                    // 月数まで表示するか否か
                    if viewModel.isDisplayAgeMonth {
                        Text("\(UserCalcUtility.currentAgeMonth(from: viewModel.targetUser.date))ヶ月")
                    }
                }
            }.circleBorderView(
                width: roundWidth,
                height: roundWidth,
                color: rootEnvironment.scheme.thema2
            )

            Text(UserCalcUtility.signOfZodiac(from: viewModel.targetUser.date))
                .circleBorderView(
                    width: roundWidth,
                    height: roundWidth,
                    color: rootEnvironment.scheme.thema4
                )

            if viewModel.targetUser.isYearsUnknown {
                Text("- 年")
                    .circleBorderView(
                        width: roundWidth,
                        height: roundWidth,
                        color: rootEnvironment.scheme.thema3
                    )
            } else {
                Text(UserCalcUtility.zodiac(from: viewModel.targetUser.date))
                    .circleBorderView(
                        width: roundWidth,
                        height: roundWidth,
                        color: rootEnvironment.scheme.thema3
                    )
            }

        }.font(DeviceSizeUtility.isSESize ? .system(size: 12) : .system(size: 17))
            .foregroundStyle(.white)
    }

    private func imageContainerView() -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 10) {
                ForEach(Array(viewModel.displayImages.enumerated()), id: \.element) { index, path in
                    AsyncImage(url: URL(fileURLWithPath: path)) { image in
                        ZStack {
                            image
                                .resizable()
                                .frame(width: 80, height: 80)
                                .onTapGesture {
                                    // プレビュー表示
                                    viewModel.showPreViewImagePopup(image: image)
                                }.onLongPressGesture {
                                    // 削除確認ダイアログの表示
                                    viewModel.showDeleteConfirmAlert(user: viewModel.targetUser, index: index)
                                }
                            // 選択中UI表示
                            if viewModel.selectedDeleteImagePath == viewModel.targetUser.imagePaths[safe: index] {
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
                    viewModel.isShowImagePicker = true
                } label: {
                    Image(systemName: "plus")
                        .fontM()
                        .frame(width: 80, height: 80)
                        .overBorder(
                            radius: 5,
                            color: rootEnvironment.scheme.foundationPrimary,
                            opacity: 0.4,
                            lineWidth: 2
                        )
                }
            }.padding(.horizontal)
        }
        .sheet(isPresented: $viewModel.isShowImagePicker) {
            ImagePickerDialog(image: $viewModel.selectedPickerImage)
        }
    }
}
