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
    @State private var sns = ""

    @State private var isAlert = false
    @State private var isValidationAlert = false

    private func validationInput() -> Bool {
        if friend.isEmpty || family.isEmpty || school.isEmpty || work.isEmpty || other.isEmpty || sns.isEmpty {
            return false
        }
        return true
    }

    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("関係カテゴリ名編集")
                .font(.system(size: 20))
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .fontWeight(.bold)
                .padding(.vertical)

            CustomInputView(title: "カテゴリ1", placeholder: RelationConfig.FRIEND_NAME, text: $friend)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ2", placeholder: RelationConfig.FAMILY_NAME, text: $family)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ3", placeholder: RelationConfig.SCHOOL_NAME, text: $school)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ4", placeholder: RelationConfig.WORK_NAME, text: $work)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ5", placeholder: RelationConfig.OTHER_NAME, text: $other)
                .environmentObject(rootEnvironment)

            CustomInputView(title: "カテゴリ6", placeholder: RelationConfig.SNS_NAME, text: $sns)
                .environmentObject(rootEnvironment)

            Spacer()

            DownSideView(parentFunction: {
                UIApplication.shared.closeKeyboard()

                guard validationInput() else {
                    isValidationAlert = true
                    return
                }
                rootEnvironment.saveRelationName(
                    friend: friend,
                    family: family,
                    school: school,
                    work: work,
                    other: other,
                    sns: sns
                )
                isAlert = true
            }, imageString: "checkmark")
                .environmentObject(rootEnvironment)

        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .font(.system(size: 17))
            .navigationBarBackButtonHidden()
            .onAppear {
                let list = rootEnvironment.relationNameList
                friend = list[safe: 0] ?? RelationConfig.FRIEND_NAME
                family = list[safe: 1] ?? RelationConfig.FAMILY_NAME
                school = list[safe: 2] ?? RelationConfig.SCHOOL_NAME
                work = list[safe: 3] ?? RelationConfig.WORK_NAME
                other = list[safe: 4] ?? RelationConfig.OTHER_NAME
                sns = list[safe: 5] ?? RelationConfig.SNS_NAME
            }.alert(
                isPresented: $isAlert,
                title: "お知らせ",
                message: "関係名を更新しました。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    dismiss()
                }
            )
            .alert(
                isPresented: $isValidationAlert,
                title: "お知らせ",
                message: "関係名を全て入力してください。",
                positiveButtonTitle: "OK",
                positiveAction: {
                    isValidationAlert = false
                }
            )
    }
}

#Preview {
    UpdateRelationNameView()
}
