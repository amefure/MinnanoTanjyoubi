//
//  UpdateRelationNameView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/23.
//

import SwiftUI

struct UpdateRelationNameView: View {
    @State private var viewModel = DIContainer.shared.resolve(UpdateRelationNameViewModel.self)
    @Environment(\.rootEnvironment) private var rootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView(scheme: rootEnvironment.state.scheme)

            Text("関係カテゴリ名編集")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.vertical)

            CustomInputView(
                title: "カテゴリ1",
                placeholder: RelationConfig.FRIEND_NAME,
                text: $viewModel.state.friend,
                scheme: rootEnvironment.state.scheme
            )

            CustomInputView(
                title: "カテゴリ2",
                placeholder: RelationConfig.FAMILY_NAME,
                text: $viewModel.state.family,
                scheme: rootEnvironment.state.scheme
            )

            CustomInputView(
                title: "カテゴリ3",
                placeholder: RelationConfig.SCHOOL_NAME,
                text: $viewModel.state.school,
                scheme: rootEnvironment.state.scheme
            )

            CustomInputView(
                title: "カテゴリ4",
                placeholder: RelationConfig.WORK_NAME,
                text: $viewModel.state.work,
                scheme: rootEnvironment.state.scheme
            )

            CustomInputView(
                title: "カテゴリ5",
                placeholder: RelationConfig.OTHER_NAME,
                text: $viewModel.state.other,
                scheme: rootEnvironment.state.scheme
            )

            CustomInputView(
                title: "カテゴリ6",
                placeholder: RelationConfig.SNS_NAME,
                text: $viewModel.state.sns,
                scheme: rootEnvironment.state.scheme
            )

            Spacer()

            DownSideView(
                parentFunction: {
                    viewModel.saveRelationName()
                },
                imageString: "checkmark",
                scheme: rootEnvironment.state.scheme
            )

        }.background(rootEnvironment.state.scheme.foundationSub)
            .onAppear { FBAnalyticsManager.loggingScreen(screen: .UpdateRelationScreen) }
            .fontM()
            .navigationBarBackButtonHidden()
            .onAppear {
                viewModel.onAppear()
            }.onDisappear {
                // 画面を離脱する際に最新の値を取得しておく
                rootEnvironment.getRelationName()
            }
            .alert(
                isPresented: $viewModel.state.isShowSuccessAlert,
                title: "お知らせ",
                message: "関係名を更新しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    dismiss()
                }
            )
            .alert(
                isPresented: $viewModel.state.isShowValidationAlert,
                title: "お知らせ",
                message: "関係名を全て入力してください。",
                positiveButtonTitle: "OK"
            )
    }
}

#Preview {
    UpdateRelationNameView()
}
