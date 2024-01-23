//
//  UpdateRelationNameView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/23.
//

import SwiftUI

struct UpdateRelationNameView: View {
    @State private var friend = ""
    @State private var family = ""
    @State private var school = ""
    @State private var work = ""
    @State private var other = ""

    @State private var isAlert = false
    @State private var isValidationAlert = false

    private func validationInput() -> Bool {
        if friend.isEmpty || family.isEmpty || school.isEmpty || work.isEmpty || other.isEmpty {
            return false
        }
        return true
    }

    // MARK: - Environment

    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    @Environment(\.dismiss) var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .padding(.bottom)

            CustomInputView(title: "カテゴリ1", placeholder: RelationConfig.FRIEND_NAME, text: $friend)

            CustomInputView(title: "カテゴリ2", placeholder: RelationConfig.FAMILY_NAME, text: $family)

            CustomInputView(title: "カテゴリ3", placeholder: RelationConfig.SCHOOL_NAME, text: $school)

            CustomInputView(title: "カテゴリ4", placeholder: RelationConfig.WORK_NAME, text: $work)

            CustomInputView(title: "カテゴリ5", placeholder: RelationConfig.OTHER_NAME, text: $other)

            Spacer()

            DownSideView(parentFunction: {
                guard validationInput() else {
                    isValidationAlert = true
                    return
                }
                rootEnvironment.saveRelationName(
                    friend: friend,
                    family: family,
                    school: school,
                    work: work,
                    other: other
                )
                isAlert = true
            }, imageString: "checkmark")

            AdMobBannerView()
                .frame(height: 60)

        }.background(ColorAsset.foundationColorLight.thisColor)
            .navigationBarBackButtonHidden()
            .onAppear {
                let list = rootEnvironment.relationNameList
                friend = list[safe: 0] ?? RelationConfig.FRIEND_NAME
                family = list[safe: 1] ?? RelationConfig.FAMILY_NAME
                school = list[safe: 2] ?? RelationConfig.SCHOOL_NAME
                work = list[safe: 3] ?? RelationConfig.WORK_NAME
                other = list[safe: 4] ?? RelationConfig.OTHER_NAME
            }.dialog(
                isPresented: $isAlert,
                title: "お知らせ",
                message: "関係名を更新しました。",
                positiveButtonTitle: "OK",
                negativeButtonTitle: "",
                positiveAction: {
                    dismiss()
                },
                negativeAction: {}
            )
            .dialog(
                isPresented: $isValidationAlert,
                title: "お知らせ",
                message: "関係名を全て入力してください。",
                positiveButtonTitle: "OK",
                negativeButtonTitle: "",
                positiveAction: {
                    isValidationAlert = false
                },
                negativeAction: {}
            )
    }
}

#Preview {
    UpdateRelationNameView()
}
