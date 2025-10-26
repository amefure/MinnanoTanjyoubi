//
//  SectionRowView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/24.
//

import SwiftUI

struct SectionRowView: View {
    // Environment
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    var users: [User]
    var title: String

    var body: some View {
        if !users.isEmpty {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(rootEnvironment.state.scheme.text)
                    .padding(.horizontal)
                    .fontM(bold: true)

                HStack {
                    Spacer()

                    Rectangle()
                        .frame(width: DeviceSizeUtility.deviceWidth - 40, height: 2)

                    Spacer()
                }.foregroundColor(rootEnvironment.state.scheme.text)

                SingleGridListView(users: users)
            }.padding()
        }
    }
}

#Preview {
    SectionRowView(users: User.demoUsers, title: "Title")
}
