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
    public var users: [User]
    public var title: String

    var body: some View {
        if !users.isEmpty {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                    .fontWeight(.bold)
                    .padding(.horizontal)
                    .font(.system(size: 17))

                HStack {
                    Spacer()

                    Rectangle()
                        .frame(width: DeviceSizeUtility.deviceWidth - 40, height: 2)

                    Spacer()
                }.foregroundColor(AppColorScheme.getText(rootEnvironment.scheme))

                SingleGridListView(users: users)
            }.padding()
        }
    }
}

#Preview {
    SectionRowView(users: User.demoUsers, title: "Title")
}
