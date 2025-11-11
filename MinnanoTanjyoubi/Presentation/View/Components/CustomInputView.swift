//
//  CustomInputView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/01/23.
//

import SwiftUI

struct CustomInputView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    /// Color Scheme
    let scheme: AppColorScheme

    var body: some View {
        HStack {
            Text(title)
                .frame(width: 80)
                .foregroundColor(scheme.text)
                .fontWeight(.bold)
            TextField(placeholder, text: $text)
                .textFieldStyle(.roundedBorder)
                .foregroundColor(.primary)
        }.padding(5)
            .fontM()
    }
}

#Preview {
    CustomInputView(
        title: "タイトル",
        placeholder: "placeholder",
        text: Binding.constant(""),
        scheme: .original
    )
}
