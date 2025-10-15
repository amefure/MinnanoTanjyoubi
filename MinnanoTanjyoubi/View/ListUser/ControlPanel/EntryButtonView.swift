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
            // 容量がオーバーしていないか または 容量解放されている
            if !repository.isOverCapacity(1) || rootEnvironment.unlockStorage {
                // 登録モーダル表示
                isModal.toggle()
            } else {
                // 容量オーバーアラート表示
                isLimitAlert = true
            }

        } label: {
            Image(systemName: "plus")
                .fontM()
        }.circleBorderView(width: 50, height: 50, color: rootEnvironment.scheme.thema3)
            .sheet(isPresented: $isModal) {
                EntryUserView(updateUserId: nil, isSelfShowModal: $isModal)
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
