//
//  ControlPanelView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/19.
//

import RealmSwift
import SwiftUI

/// リスト画面下部に表示するコントロールパネルビュー
struct ControlPanelView: View {
    // Environment
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Binding var isDeleteAlert: Bool
    @Binding var isLimitAlert: Bool

    var body: some View {
        HStack {
            Spacer()

            RemoveButtonView(isDeleteAlert: $isDeleteAlert)
                .environmentObject(rootEnvironment)

            Spacer()

            SortedButtonView()
                .environmentObject(rootEnvironment)

            Spacer()

            EntryButtonView(isLimitAlert: $isLimitAlert)
                .environmentObject(rootEnvironment)

            Spacer()

        }.frame(width: DeviceSizeUtility.deviceWidth, height: 70)
            // .foregroundColor(AppColorScheme.getText(rootEnvironment.scheme))
            .foregroundStyle(.white)
            .background(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
    }
}
