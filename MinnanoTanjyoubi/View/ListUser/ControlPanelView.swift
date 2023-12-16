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

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        HStack {
            Spacer()

            // MARK: - RemoveButton

            RemoveButtonView()
                .environmentObject(rootEnvironment)

            Spacer()

            // MARK: - SortedButton

            SortedButtonView()

            Spacer()

            // MARK: - EntryButton

            EntryButtonView()

            Spacer()

        }.frame(width: DeviceSizeManager.deviceWidth, height: 70)
            .foregroundColor(.white)
            .background(ColorAsset.foundationColorDark.thisColor)
    }
}
