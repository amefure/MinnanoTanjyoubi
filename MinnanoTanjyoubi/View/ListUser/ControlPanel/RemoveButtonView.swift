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

    @Binding var isDeleteAlert: Bool

    @EnvironmentObject private var rootEnvironment: RootEnvironment

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
                .font(.system(size: 17))
        }).circleBorderView(width: 50, height: 50, color: AppColorScheme.getThema2(rootEnvironment.scheme))
    }
}
