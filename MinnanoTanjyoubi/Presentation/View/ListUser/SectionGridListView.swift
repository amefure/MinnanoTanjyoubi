//
//  SectionGridListView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/24.
//

import SwiftUI

struct SectionGridListView: View {
    var users: [User]
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    var body: some View {
        SectionRowView(
            users: users.filter { $0.relation == .friend },
            title: rootEnvironment.relationNameList[safe: 0] ?? RelationConfig.FRIEND_NAME
        ).environmentObject(rootEnvironment)

        SectionRowView(
            users: users.filter { $0.relation == .family },
            title: rootEnvironment.relationNameList[safe: 1] ?? RelationConfig.FAMILY_NAME
        ).environmentObject(rootEnvironment)

        SectionRowView(
            users: users.filter { $0.relation == .school },
            title: rootEnvironment.relationNameList[safe: 2] ?? RelationConfig.SCHOOL_NAME
        ).environmentObject(rootEnvironment)

        SectionRowView(
            users: users.filter { $0.relation == .work },
            title: rootEnvironment.relationNameList[safe: 3] ?? RelationConfig.WORK_NAME
        ).environmentObject(rootEnvironment)

        SectionRowView(
            users: users.filter { $0.relation == .other },
            title: rootEnvironment.relationNameList[safe: 4] ?? RelationConfig.OTHER_NAME
        ).environmentObject(rootEnvironment)

        SectionRowView(
            users: users.filter { $0.relation == .sns },
            title: rootEnvironment.relationNameList[safe: 5] ?? RelationConfig.SNS_NAME
        ).environmentObject(rootEnvironment)
    }
}

#Preview {
    SectionGridListView(users: User.demoUsers)
        .environmentObject(DIContainer.shared.resolve(RootEnvironment.self))
}
