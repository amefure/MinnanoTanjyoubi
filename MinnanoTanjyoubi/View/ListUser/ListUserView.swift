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

    @ObservedResults(User.self) var users

    // MARK: - Controller

    private let realmCrudManager = RealmCrudManager()

    // MARK: - View

    /// LINK: HeaderView
    @Binding var isSettingActive: Bool
    /// LINK: ControlPanelView / CheckRowUserView
    @State var isDeleteMode: Bool = false
    @State var deleteIdArray: [ObjectId] = []
    @State var isSorted: Bool = false
    @State var selectedRelation: Relation = .other

    // MARK: - Setting

    private let deviceWidth = DeviceSizeManager.deviceWidth
    private let deviceHeight = DeviceSizeManager.deviceHeight
    private let isSESize = DeviceSizeManager.isSESize

    // MARK: - Glid Layout

    private var gridItemWidth: CGFloat {
        return CGFloat(deviceWidth / 3) - 10
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(gridItemWidth)), count: 3)
    }

    // MARK: - Glid Layout

    private var sortedUsers: [User] {
        if isSorted {
            return users.filter { $0.relation == selectedRelation }
        } else {
            return users.sorted(by: { $0.daysLater < $1.daysLater })
        }
    }

    var body: some View {
        VStack(spacing: 0) {
            // MARK: - List Contents

            ScrollView {
                LazyVGrid(columns: gridColumns) {
                    // MARK: - 誕生日までの日付が近い順にソート

                    ForEach(sortedUsers) { user in
                        if isDeleteMode {
                            // DeleteMode
                            CheckRowUserView(user: user, deleteIdArray: $deleteIdArray)
                        } else {
                            // NormalMode
                            NavigationLink(destination: DetailUserView(user: user), label: {
                                RowUserView(user: user)
                            })
                        }
                    }
                }
            }.padding([.top, .trailing, .leading])

            // MARK: - ControlPanel

            ControlPanelView(isSorted: $isSorted, isDeleteMode: $isDeleteMode, deleteIdArray: $deleteIdArray, selectedRelation: $selectedRelation)

        }.background(ColorAsset.foundationColorLight.thisColor)
            .navigationDestination(isPresented: $isSettingActive) {
                SettingView()
            }
    }
}
