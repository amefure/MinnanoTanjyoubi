//
//  SectionGridListView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/24.
//

import SwiftUI

struct SectionGridListView: View {
    var users: [User]
    @Environment(\.rootEnvironment) private var rootEnvironment

    var body: some View {
        SectionRowView(
            users: users.filter { $0.relation == .friend },
            title: rootEnvironment.state.relationNameList[safe: 0] ?? RelationConfig.FRIEND_NAME
        )

        SectionRowView(
            users: users.filter { $0.relation == .family },
            title: rootEnvironment.state.relationNameList[safe: 1] ?? RelationConfig.FAMILY_NAME
        )

        SectionRowView(
            users: users.filter { $0.relation == .school },
            title: rootEnvironment.state.relationNameList[safe: 2] ?? RelationConfig.SCHOOL_NAME
        )

        SectionRowView(
            users: users.filter { $0.relation == .work },
            title: rootEnvironment.state.relationNameList[safe: 3] ?? RelationConfig.WORK_NAME
        )

        SectionRowView(
            users: users.filter { $0.relation == .other },
            title: rootEnvironment.state.relationNameList[safe: 4] ?? RelationConfig.OTHER_NAME
        )

        SectionRowView(
            users: users.filter { $0.relation == .sns },
            title: rootEnvironment.state.relationNameList[safe: 5] ?? RelationConfig.SNS_NAME
        )
    }
}

#Preview {
    SectionGridListView(users: User.demoUsers)
}
