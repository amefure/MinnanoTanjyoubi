//
//  SingleGridListView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/24.
//

import SwiftUI

struct SingleGridListView: View {
    var users: [User]

    @Environment(\.rootEnvironment) private var rootEnvironment

    private var gridItemWidth: CGFloat {
        CGFloat(DeviceSizeUtility.deviceWidth / 3) - 10
    }

    private var gridColumns: [GridItem] {
        Array(repeating: GridItem(.fixed(gridItemWidth)), count: 3)
    }

    var body: some View {
        LazyVGrid(columns: gridColumns) {
            ForEach(users) { user in
                if rootEnvironment.state.isDeleteMode {
                    // DeleteMode
                    CheckRowUserView(user: user)
                        .environment(\.rootEnvironment, rootEnvironment)
                } else {
                    // NormalMode
                    NavigationLink {
                        DetailUserView(userId: user.id)
                            .environment(\.rootEnvironment, rootEnvironment)
                    } label: {
                        RowUserView(user: user)
                            .environment(\.rootEnvironment, rootEnvironment)
                    }.buttonStyle(.plain)
                }
            }
        }
    }
}

#Preview {
    SingleGridListView(users: User.demoUsers)
}
