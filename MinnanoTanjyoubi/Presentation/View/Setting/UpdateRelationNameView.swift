//
//  UpdateRelationNameView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/23.
//

import SwiftUI

struct UpdateRelationNameView: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(UpdateRelationNameViewModel.self)
    @Environment(\.rootEnvironment) private var rootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environment(\.rootEnvironment, rootEnvironment)

            Text("関係カテゴリ名編集")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.vertical)

            CustomInputView(title: "カテゴリ1", placeholder: RelationConfig.FRIEND_NAME, text: $viewModel.friend)
                .environment(\.rootEnvironment, rootEnvironment)

            CustomInputView(title: "カテゴリ2", placeholder: RelationConfig.FAMILY_NAME, text: $viewModel.family)
                .environment(\.rootEnvironment, rootEnvironment)

            CustomInputView(title: "カテゴリ3", placeholder: RelationConfig.SCHOOL_NAME, text: $viewModel.school)
                .environment(\.rootEnvironment, rootEnvironment)

            CustomInputView(title: "カテゴリ4", placeholder: RelationConfig.WORK_NAME, text: $viewModel.work)
                .environment(\.rootEnvironment, rootEnvironment)

            CustomInputView(title: "カテゴリ5", placeholder: RelationConfig.OTHER_NAME, text: $viewModel.other)
                .environment(\.rootEnvironment, rootEnvironment)

            CustomInputView(title: "カテゴリ6", placeholder: RelationConfig.SNS_NAME, text: $viewModel.sns)
                .environment(\.rootEnvironment, rootEnvironment)

            Spacer()

            DownSideView(
                parentFunction: {
                    viewModel.saveRelationName()

                },
                imageString: "checkmark"
            ).environment(\.rootEnvironment, rootEnvironment)

        }.background(rootEnvironment.state.scheme.foundationSub)
            .onAppear { FBAnalyticsManager.loggingScreen(screen: .UpdateRelationScreen) }
            .fontM()
            .navigationBarBackButtonHidden()
            .onAppear {
                let list = rootEnvironment.state.relationNameList
                viewModel.onAppear(relationList: list)
            }.onDisappear {
                // 画面を離脱する際に最新の値を取得しておく
                rootEnvironment.getRelationName()
            }
            .alert(
                isPresented: $viewModel.isShowSuccessAlert,
                title: "お知らせ",
                message: "関係名を更新しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    dismiss()
                }
            )
            .alert(
                isPresented: $viewModel.isShowValidationAlert,
                title: "お知らせ",
                message: "関係名を全て入力してください。",
                positiveButtonTitle: "OK"
            )
    }
}

#Preview {
    UpdateRelationNameView()
        .environment(\.rootEnvironment, DIContainer.shared.resolve(RootEnvironment.self))
}
