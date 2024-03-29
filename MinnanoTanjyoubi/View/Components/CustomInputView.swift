//
//  CustomInputView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/23.
//

import SwiftUI

struct CustomInputView: View {
    public var title: String
    public var placeholder: String
    @Binding var text: String

    var body: some View {
        HStack {
            Text(title)
                .frame(width: 80)
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(.primary)
        }.padding(5)
    }
}

#Preview {
    CustomInputView(title: "タイトル", placeholder: "placeholder", text: Binding.constant(""))
}
