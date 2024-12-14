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

    // Storage
    @AppStorage("LimitCapacity") var limitCapacity = AdsConfig.INITIAL_CAPACITY // 初期値

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    // 上限に達した場合のアラート
    @State private var isLimitAlert: Bool = false
    @State private var isModal = false

    private func checkLimitCapacity() -> Bool {
        if repository.users.count >= limitCapacity {
            isLimitAlert = true
            return false
        } else {
            return true
        }
    }

    var body: some View {
        Button {
            if checkLimitCapacity() {
                isModal.toggle()
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
                title: "お知らせ",
                message: "保存容量が上限に達しました...\n設定から広告を視聴すると\n保存容量を増やすことができます。",
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
