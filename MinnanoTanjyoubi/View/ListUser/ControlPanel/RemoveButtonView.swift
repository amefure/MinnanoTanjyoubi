//
//  RemoveButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import RealmSwift
import SwiftUI

struct RemoveButtonView: View {
    @ObservedObject private var repository = RealmRepositoryViewModel.shared

    // MARK: - View

    @Binding var isDeleteAlert: Bool

    // MARK: - Environment

    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    var body: some View {
        Button(action: {
            if rootEnvironment.deleteIdArray.count != 0 {
                isDeleteAlert = true
            } else {
                if rootEnvironment.isDeleteMode {
                    rootEnvironment.disableDeleteMode()
                } else {
                    rootEnvironment.enableDeleteMode()
                }
            }
        }, label: {
            Image(systemName: rootEnvironment.isDeleteMode ? "trash" : "app.badge.checkmark")
        }).circleBorderView(width: 50, height: 50, color: Asset.Colors.themaColor2.swiftUIColor)
    }
}
