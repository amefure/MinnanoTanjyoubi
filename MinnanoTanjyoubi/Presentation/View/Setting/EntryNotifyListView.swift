//
//  EntryNotifyListView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import SwiftUI

struct EntryNotifyListView: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(EntryNotifyListViewModel.self)
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            HStack {
                Spacer()
                    .frame(width: 80)
                Spacer()
                Text("登録済み通知一覧")
                    .fontL(bold: true)
                    .foregroundStyle(rootEnvironment.scheme.text)
                    .padding(.vertical)
                Spacer()

                if viewModel.notifyList.isEmpty {
                    Spacer()
                        .frame(width: 80)
                } else {
                    Button {
                        viewModel.isShowConfirmAllDeleteAlert = true
                    } label: {
                        Text("ALL\nRESET")
                    }.frame(width: 80)
                        .padding(.vertical, 3)
                        .background(Asset.Colors.exThemaRed.swiftUIColor)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                        .fontSS(bold: true)
                        .shadow(color: .gray, radius: 3, x: 3, y: 3)
                }
            }.padding(.horizontal)

            if viewModel.isFetching {
                ProgressView()
            } else if viewModel.notifyList.isEmpty {
                noDataView()
            } else {
                List(viewModel.notifyList) { notify in
                    DemoNotifyView(
                        msg: notify.message,
                        time: viewModel.convertDateTime(notify.date)
                    ).listRowBackground(rootEnvironment.scheme.foundationSub)
                        .onTapGesture {
                            viewModel.setTargetNotify(notify)
                        }
                }.scrollContentBackground(.hidden)
                    .background(rootEnvironment.scheme.foundationSub)
            }

            Spacer()

        }.onAppear {
            viewModel.onAppear()
        }.background(rootEnvironment.scheme.foundationSub)
            .ignoresSafeArea(.keyboard)
            .fontM()
            .navigationBarBackButtonHidden()
            .alert(
                isPresented: $viewModel.isShowSuccessDeleteAlert,
                title: "成功",
                message: "通知の予定をキャンセルしました。"
            ).alert(
                isPresented: $viewModel.isShowFailedDeleteAlert,
                title: "Erroe",
                message: "通知の予定のキャンセルに失敗しました。何度も繰り返される場合は「ALLRESET」で一度リセットしてください。"
            )
            .alert(
                isPresented: $viewModel.isShowConfirmDeleteAlert,
                title: "お知らせ",
                message: "通知の予定をキャンセルしますか？",
                positiveButtonTitle: "はい",
                negativeButtonTitle: "いいえ",
                positiveButtonRole: .destructive,
                positiveAction: {
                    // 通知削除
                    viewModel.deleteTargetNotify()
                },
                negativeAction: {
                    // キャンセル
                    viewModel.setTargetNotify(nil)
                }
            ).alert(
                isPresented: $viewModel.isShowConfirmAllDeleteAlert,
                title: "注意",
                message: "予定されている通知を本当に全てキャンセルしますか？",
                positiveButtonTitle: "はい",
                negativeButtonTitle: "いいえ",
                positiveButtonRole: .destructive,
                positiveAction: {
                    // 通知削除
                    viewModel.deleteAllNotify()
                }
            )
    }

    private func noDataView() -> some View {
        VStack {
            Spacer()

            Text("登録されている通知はありません。")
                .fontM(bold: true)
                .foregroundStyle(rootEnvironment.scheme.text)

            Spacer()
        }
    }
}

#Preview {
    EntryNotifyListView()
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
