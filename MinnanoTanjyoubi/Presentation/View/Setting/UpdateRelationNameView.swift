//
//  UpdateRelationNameView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/23.
//

import SwiftUI

struct UpdateRelationNameView: View {
    @StateObject private var viewModel = DIContainer.shared.resolve(UpdateRelationNameViewModel.self)
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("関係カテゴリ名編集")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.vertical)

            CustomInputView(title: "カテゴリ1", placeholder: RelationConfig.FRIEND_NAME, text: $viewModel.friend)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ2", placeholder: RelationConfig.FAMILY_NAME, text: $viewModel.family)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ3", placeholder: RelationConfig.SCHOOL_NAME, text: $viewModel.school)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ4", placeholder: RelationConfig.WORK_NAME, text: $viewModel.work)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ5", placeholder: RelationConfig.OTHER_NAME, text: $viewModel.other)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ6", placeholder: RelationConfig.SNS_NAME, text: $viewModel.sns)
                .environmentObject(rootEnvironment)

            Spacer()

            DownSideView(parentFunction: {
                viewModel.saveRelationName()
            }, imageString: "checkmark")
                .environmentObject(rootEnvironment)

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
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
