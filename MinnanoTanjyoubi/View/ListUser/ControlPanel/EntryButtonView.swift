//
//  EntryButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import RealmSwift
import SwiftUI

struct EntryButtonView: View {
    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    // 上限に達した場合のアラート
    @State private var isLimitAlert: Bool = false
    @State private var isModal = false

    var body: some View {
        Button {
            // 新規登録画面表示前に容量チェック
            if !repository.isOverCapacity(1) {
                isModal.toggle()
            } else {
                isLimitAlert = true
            }

        } label: {
            Image(systemName: "plus")
                .font(.system(size: 17))
        }.circleBorderView(width: 50, height: 50, color: AppColorScheme.getThema3(rootEnvironment.scheme))
            .sheet(isPresented: $isModal) {
                EntryUserView(user: nil, isModal: $isModal)
                    .environmentObject(rootEnvironment)
            }.alert(
                isPresented: $isLimitAlert,
                title: "Error...",
                message: "保存容量が上限に達しました。\n設定から広告を視聴すると\n保存容量を増やすことができます。",
                positiveButtonTitle: "OK",
                negativeButtonTitle: "",
                positiveAction: {
                    isLimitAlert = false
                },
                negativeAction: {}
            )
    }
}

#Preview {
    EntryButtonView()
        .environmentObject(RootEnvironment())
}
