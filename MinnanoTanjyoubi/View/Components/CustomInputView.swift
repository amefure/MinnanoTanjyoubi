//
//  CustomInputView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/23.
//

import SwiftUI

struct CustomInputView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment

    public var title: String
    public var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Text(title)
                .frame(width: 80)
                .foregroundColor(rootEnvironment.scheme.text)
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
}
