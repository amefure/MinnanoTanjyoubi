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

    @StateObject private var viewModel = DetailViewModel()

    @EnvironmentObject private var rootEnvironment: RootEnvironment
    
    private let dfm = DateFormatUtility()

    @State private var image: UIImage?
    @State private var images: [String] = []

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
                        .frame(
                            width: viewModel.deviceWidth - 40,
                            height: viewModel.isSESize ? 130 : 200,
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
                
            }.padding(viewModel.isSESize ? 5 : 10)
            
            // 通知トグルビュー
            Toggle("通知", isOn: $viewModel.isNotifyFlag)
                .toggleStyle(
                    SwitchToggleStyle(tint: rootEnvironment.scheme.thema1)
                ).fontM()
                .frame(width: DeviceSizeUtility.deviceWidth - 60)
                .padding(DeviceSizeUtility.isSESize ? 5 : 10)
            
            // 追加しても更新されないので明示的にidを指定する
            imageContainerView()
                .id(viewModel.isUpdateImageContainerView)
            
            Spacer()
            
            DownSideView(
                parentFunction: {
                    viewModel.isShowUpdateModalView = true
                }, 
                imageString: "square.and.pencil"
            ).sheet(isPresented: $viewModel.isShowUpdateModalView) {
                EntryUserView(user: user, isModal: $viewModel.isShowUpdateModalView)
            }.environmentObject(rootEnvironment)

            if !viewModel.isSESize && !rootEnvironment.removeAds {
                AdMobBannerView()
                    .frame(height: 50)
            }

        }.background(rootEnvironment.scheme.foundationSub)
            .foregroundStyle(rootEnvironment.scheme.text)
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
    
    /// Relation/あと何日../名前/ふりがな/生年月日/和暦
    private func upSideUserInfoView() -> some View {
        VStack(spacing: 0) {
            HStack {
                Text(rootEnvironment.relationNameList[safe: user.relation.relationIndex] ?? "その他")
                    .padding(8)
                    .multilineTextAlignment(.center)
                    .frame(minWidth: viewModel.roundWidth, alignment: .center)
                    .frame(maxWidth: viewModel.roundWidth * 1.5)
                    .lineLimit(1)
                    .background(rootEnvironment.scheme.foundationPrimary)
                    .cornerRadius(5)
                    .font(viewModel.isSESize ? .system(size: 12) : .system(size: 17))

                Spacer()

                HStack(alignment: .bottom) {
                    let daysLater = UserCalcUtility.daysLater(from: user.date)
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
                    .frame(minWidth: viewModel.roundWidth, alignment: .center)
                    .background(rootEnvironment.scheme.foundationPrimary)
                    .cornerRadius(5)
                    .font(viewModel.isSESize ? .system(size: 12) : .system(size: 17))
            }

            Text(user.ruby)
                .font(viewModel.isSESize ? .system(size: 12) : .system(size: 14))
            Text(user.name)
                .font(viewModel.isSESize ? .system(size: 17) : .system(size: 20))
            HStack {
                if user.isYearsUnknown {
                    Text(dfm.getJpStringOnlyDate(date: user.date))
                    Text("（年数未設定）")
                } else {
                    Text(dfm.getJpString(date: user.date))
                    Text("（\(dfm.getJpEraString(date: user.date))）")
                }
            }.padding(.top, 8)
                .fontM()
        }
    }
    
    /// 年齢/星座/干支
    private func middleUserInfoView() -> some View {
        HStack(spacing: 20) {
            VStack {
                if user.isYearsUnknown {
                    Text("- 歳")
                } else {
                    Text("\(UserCalcUtility.currentAge(from: user.date))歳")
                    // 月数まで表示するか否か
                    if viewModel.isDisplayAgeMonth {
                        Text("\(UserCalcUtility.currentAgeMonth(from: user.date))ヶ月")
                    }
                }
            }.circleBorderView(width: viewModel.roundWidth, height: viewModel.roundWidth, color: rootEnvironment.scheme.thema2)

            Text(UserCalcUtility.signOfZodiac(from: user.date))
                .circleBorderView(width: viewModel.roundWidth, height: viewModel.roundWidth, color: rootEnvironment.scheme.thema4)

            if user.isYearsUnknown {
                Text("- 年")
                    .circleBorderView(width: viewModel.roundWidth, height: viewModel.roundWidth, color: rootEnvironment.scheme.thema3)
            } else {
                Text(UserCalcUtility.zodiac(from: user.date))
                    .circleBorderView(width: viewModel.roundWidth, height: viewModel.roundWidth, color: rootEnvironment.scheme.thema3)
            }

        }.font(viewModel.isSESize ? .system(size: 12) : .system(size: 17))
            .foregroundStyle(.white)
    }
    
    private func imageContainerView() -> some View {
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
