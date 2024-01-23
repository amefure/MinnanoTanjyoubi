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

    var body: some View {
        HStack {
            Spacer()

            // MARK: - RemoveButton

            RemoveButtonView()

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
