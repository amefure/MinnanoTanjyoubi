//
//  ListUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/09/30.
//

import RealmSwift
import SwiftUI
import UIKit

// MARK: - データをリスト表示するビュー

struct ListUserView: View {
    // MARK: - Models

    @ObservedObject private var repository = RealmRepositoryViewModel.shared

    // MARK: - Environment

    @EnvironmentObject private var rootEnvironment: RootEnvironment

    // MARK: - Glid Layout

    private var gridItemWidth: CGFloat {
        return CGFloat(DeviceSizeManager.deviceWidth / 3) - 10
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(gridItemWidth)), count: 3)
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - List Contents

            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    ForEach(repository.users) { user in
                        if rootEnvironment.isDeleteMode {
                            // DeleteMode
                            CheckRowUserView(user: user)
                                .environmentObject(rootEnvironment)
                        } else {
                            // NormalMode
                            NavigationLink {
                                DetailUserView(user: user)
                                    .environmentObject(rootEnvironment)
                            } label: {
                                RowUserView(user: user)
                            }
                        }
                    }
                }
            }.padding([.top, .trailing, .leading])

            // MARK: - ControlPanel

            ControlPanelView()
                .environmentObject(rootEnvironment)

        }.background(ColorAsset.foundationColorLight.thisColor)
    }
}