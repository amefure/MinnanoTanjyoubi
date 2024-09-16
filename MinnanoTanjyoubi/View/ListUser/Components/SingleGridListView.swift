//
//  SingleGridListView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/24.
//

import SwiftUI

struct SingleGridListView: View {
    public var users: [User]

    @ObservedObject private var rootEnvironment = RootEnvironment.shared

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
                } else {
                    // NormalMode
                    NavigationLink {
                        DetailUserView(user: user)
                    } label: {
                        RowUserView(user: user)
                    }
                }
            }
        }
    }
}

#Preview {
    SingleGridListView(users: User.demoUsers)
}
