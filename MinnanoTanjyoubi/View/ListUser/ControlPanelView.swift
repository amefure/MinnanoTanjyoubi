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
    @Binding var isScrollingDown: Bool

    var body: some View {
        let tapGesture = TapGesture()
            .onEnded {
                isScrollingDown = false
            }
        HStack {
            Spacer()

            RemoveButtonView()
                .environmentObject(rootEnvironment)
                .simultaneousGesture(tapGesture)

            Spacer()

            SortedButtonView()
                .environmentObject(rootEnvironment)
                .simultaneousGesture(tapGesture)

            Spacer()

            EntryButtonView()
                .environmentObject(rootEnvironment)
                .simultaneousGesture(tapGesture)

            Spacer()

        }.frame(width: DeviceSizeUtility.deviceWidth, height: 70)
            .foregroundStyle(rootEnvironment.scheme.controlText)
            .background(AppColorScheme.getFoundationPrimary(rootEnvironment.scheme))
    }
}
