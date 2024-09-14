//
//  EntryButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import RealmSwift
import SwiftUI

struct EntryButtonView: View {
    // MARK: - Models

    @ObservedObject private var repository = RealmRepositoryViewModel.shared

    // Storage
    @AppStorage("LimitCapacity") var limitCapacity = AdsConfig.INITIAL_CAPACITY // 初期値

    // MARK: - View

    // 上限に達した場合のアラート
    @Binding var isLimitAlert: Bool
    @State private var isModal: Bool = false

    private func checkLimitCapacity() -> Bool {
        if repository.users.count >= limitCapacity {
            isLimitAlert = true
            return false
        } else {
            return true
        }
    }

    var body: some View {
        Button(action: {
            if checkLimitCapacity() {
                isModal.toggle()
            }

        }, label: {
            Image(systemName: "plus")
                .font(.system(size: 17))
        })
        .circleBorderView(width: 50, height: 50, color: Asset.Colors.themaColor3.swiftUIColor)
        .sheet(isPresented: $isModal, content: {
            EntryUserView(user: nil, isModal: $isModal)
        })
    }
}

struct EntryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EntryButtonView(isLimitAlert: Binding.constant(false))
    }
}
