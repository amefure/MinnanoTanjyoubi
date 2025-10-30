//
//  CustomInputView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/23.
//

import SwiftUI

struct CustomInputView: View {
    @Environment(\.rootEnvironment) private var rootEnvironment

    var title: String
    var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Text(title)
                .frame(width: 80)
                .foregroundColor(rootEnvironment.state.scheme.text)
                .fontWeight(.bold)
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(.primary)
        }.padding(5)
            .font(.system(size: 16))
    }
}

#Preview {
    CustomInputView(title: "タイトル", placeholder: "placeholder", text: Binding.constant(""))
        .environment(\.rootEnvironment, DIContainer.shared.resolve(RootEnvironment.self))
}
