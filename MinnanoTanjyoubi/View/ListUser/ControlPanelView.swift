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

    @ObservedObject private var rootEnvironment = RootEnvironment.shared
    @Binding var isDeleteAlert: Bool
    @Binding var isLimitAlert: Bool

    var body: some View {
        HStack {
            Spacer()


            RemoveButtonView(isDeleteAlert: $isDeleteAlert)

            Spacer()

            SortedButtonView()

            Spacer()

            EntryButtonView(isLimitAlert: $isLimitAlert)

            Spacer()

        }.frame(width: DeviceSizeUtility.deviceWidth, height: 70)
            .foregroundColor(.white)
            .background(Asset.Colors.foundationColorDark.swiftUIColor)
    }
}
