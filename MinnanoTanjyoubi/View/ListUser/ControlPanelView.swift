//
//  ControlPanelView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/19.
//

import RealmSwift
import SwiftUI

// MARK: - リスト画面下部に表示するコントロールパネルビュー

struct ControlPanelView: View {
    // MARK: - Environment

    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    @Binding var isDeleteAlert: Bool
    @Binding var isLimitAlert: Bool

    var body: some View {
        HStack {
            Spacer()

            // MARK: - RemoveButton

            RemoveButtonView(isDeleteAlert: $isDeleteAlert)

            Spacer()

            // MARK: - SortedButton

            SortedButtonView()

            Spacer()

            // MARK: - EntryButton

            EntryButtonView(isLimitAlert: $isLimitAlert)

            Spacer()

        }.frame(width: DeviceSizeUtility.deviceWidth, height: 70)
            .foregroundColor(.white)
            .background(Asset.Colors.foundationColorDark.swiftUIColor)
    }
}
