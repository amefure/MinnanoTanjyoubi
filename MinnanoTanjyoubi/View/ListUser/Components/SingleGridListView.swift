//
//  SingleGridListView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/24.
//

import SwiftUI

struct SingleGridListView: View {
    public var users: [User]

    // Environment
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    private var gridItemWidth: CGFloat {
        return CGFloat(DeviceSizeUtility.deviceWidth / 3) - 10
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(gridItemWidth)), count: 3)
    }

    var body: some View {
        LazyVGrid(columns: gridColumns) {
            ForEach(users) { user in
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
                            .environmentObject(rootEnvironment)
                    }.buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    SingleGridListView(users: User.demoUsers)
}
