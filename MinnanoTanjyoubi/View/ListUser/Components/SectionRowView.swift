//
//  SectionRowView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/24.
//

import SwiftUI

struct SectionRowView: View {
    public var users: [User]

    public var title: String

    var body: some View {
        if users.count != 0 {
            VStack(alignment: .leading) {
                Text(title)
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .padding(.horizontal)

                HStack {
                    Spacer()

                    Rectangle()
                        .frame(width: DeviceSizeManager.deviceWidth - 40, height: 2)

                    Spacer()
                }

                .foregroundColor(.white)

                SingleGridListView(users: users)
            }.padding()
        }
    }
}

#Preview {
    SectionRowView(users: User.demoUsers, title: "Title")
}
