//
//  InAppPurchaseView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/23.
//

import SwiftUI

struct InAppPurchaseView: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(InAppPurchaseViewModel.self)
    @Environment(\.rootEnvironment) private var rootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environment(\.rootEnvironment, rootEnvironment)

            Text("広告削除 & 容量解放")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.vertical)

            Text("購入後のキャンセルは致しかねますのでご了承ください。")
                .fontS()
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.horizontal)

            if viewModel.fetchError {
                Spacer()

                VStack {
                    Text("ERROR")
                        .fontL(bold: true)

                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .foregroundStyle(rootEnvironment.state.scheme.text)
                        .padding(.vertical)

                    Text("課金アイテムの取得に失敗しました。\nネットワークの接続を確認してください。")
                        .fontM(bold: true)

                }.frame(width: DeviceSizeUtility.deviceWidth)
                    .foregroundStyle(rootEnvironment.state.scheme.text)
                    .padding(.bottom, 30)

                Spacer()
            } else {
                List {
                    ForEach(viewModel.products) { product in
                        Section {
                            VStack(spacing: 8) {
                                Text(product.value.displayName)
                                    .fontM(bold: true)
                                    .frame(width: DeviceSizeUtility.deviceWidth - 60, alignment: .leading)

                                Text("・\(product.value.description)")
                                    .fontS()
                                    .frame(width: DeviceSizeUtility.deviceWidth - 60, alignment: .leading)

                                Text(product.value.displayPrice)
                                    .fontM(bold: true)

                                Button {
                                    viewModel.purchase(product: product.value)
                                } label: {
                                    if viewModel.isPurchasingId == product.id {
                                        ProgressView()
                                            .tint(.white)
                                            .foregroundStyle(.white)
                                            .frame(width: DeviceSizeUtility.deviceWidth - 60, height: 50)
                                            .background(Asset.Colors.exThemaRed.swiftUIColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .shadow(color: .gray, radius: 3, x: 4, y: 4)
                                    } else {
                                        Text(product.isPurchased ? "購入済み" : "購入する")
                                            .foregroundStyle(.white)
                                            .frame(width: DeviceSizeUtility.deviceWidth - 60, height: 50)
                                            .background(Asset.Colors.exThemaRed.swiftUIColor)
                                            .clipShape(RoundedRectangle(cornerRadius: 8))
                                            .shadow(color: .gray, radius: 3, x: 4, y: 4)
                                    }
                                }.buttonStyle(.plain)
                                    .disabled(product.isPurchased)
                                    .disabled(viewModel.isPurchasingId == product.id)
                            }
                        }
                    }

                    VStack(spacing: 8) {
                        Text("購入アイテムを復元する")
                            .fontM(bold: true)
                            .frame(width: DeviceSizeUtility.deviceWidth - 60, alignment: .leading)

                        Text("・一度ご購入いただけますと、\nアプリ再インストール時に「復元する」ボタンから\n復元が可能となっています。")
                            .fontS()
                            .frame(width: DeviceSizeUtility.deviceWidth - 60, alignment: .leading)

                        Button {
                            viewModel.restore()
                        } label: {
                            Text("復元する")
                                .foregroundStyle(.white)
                                .frame(width: DeviceSizeUtility.deviceWidth - 60, height: 50)
                                .background(Asset.Colors.exThemaRed.swiftUIColor)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .shadow(color: .gray, radius: 3, x: 4, y: 4)
                        }.buttonStyle(.plain)
                    }
                }.scrollContentBackground(.hidden)
                    .background(rootEnvironment.state.scheme.foundationSub)
                    .foregroundStyle(Asset.Colors.exText.swiftUIColor)
            }

        }.onAppear { viewModel.onAppear() }
            .onDisappear {
                viewModel.onDisappear()

                if viewModel.didPurchase {
                    // 課金購入が発生していればRootEnviroment側でもアイテムを再取得する
                    rootEnvironment.listenInAppPurchase()
                }
            }
            .background(rootEnvironment.state.scheme.foundationSub)
            .ignoresSafeArea(.keyboard)
            .fontM()
            .navigationBarBackButtonHidden()
            .alert(
                isPresented: $viewModel.purchaseError,
                title: "Error",
                message: "アイテムの購入に失敗しました。\nこの取引では料金は徴収されません。\nしばらく時間をおいてから再度お試しください。",
                positiveButtonTitle: "OK",
                negativeButtonTitle: "",
                positiveAction: {
                    viewModel.purchaseError = false
                },
                negativeAction: {}
            ).alert(
                isPresented: $viewModel.successRestoreAlert,
                title: "成功",
                message: "購入アイテムの復元に成功しました。\n購入アイテムがそれでも復元されない場合はお手数ですがお問合せください。",
                positiveButtonTitle: "OK"
            )
            .alert(
                isPresented: $viewModel.failedRestoreAlert,
                title: "Error",
                message: "購入アイテムの復元に失敗しました。\n時間を開けてから再度お試しください。",
                positiveButtonTitle: "OK"
            )
    }
}

// struct IAPView: View {
//    var body: some View {
//        if #available(iOS 17.0, *) {
//            ProductView(id: "remove_ads")
//                .productViewStyle(.large)
//                .onInAppPurchaseCompletion { _, result in
//                    if case .success(.success(_)) = result {
//                        // 課金が成功した場合の処理
//                    } else {
//                        // 課金が失敗した場合の処理
//                    }
//                }
//        } else {
//            // Fallback on earlier versions
//        }
//    }
// }

#Preview {
    InAppPurchaseView()
        .environment(\.rootEnvironment, DIContainer.shared.resolve(RootEnvironment.self))
}
