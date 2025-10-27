//
//  FaqListView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/10/01.
//

import SwiftUI

struct FaqListView: View {
    @Environment(\.rootEnvironment) private var rootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environment(\.rootEnvironment, rootEnvironment)

            Text("よくある質問")
                .fontL(bold: true)
                .foregroundStyle(rootEnvironment.state.scheme.text)
                .padding(.vertical)

            List {
                Section {
                    AccordionBoxView(question: L10n.howToUseQ1Title, answer: L10n.howToUseQ1Text)
                    AccordionBoxView(question: L10n.howToUseQ2Title, answer: L10n.howToUseQ2Text)
                    AccordionBoxView(question: L10n.howToUseQ3Title, answer: L10n.howToUseQ3Text)
                    AccordionBoxView(question: L10n.howToUseQ4Title, answer: L10n.howToUseQ4Text)
                    AccordionBoxView(question: L10n.howToUseQ5Title, answer: L10n.howToUseQ5Text)
                    AccordionBoxView(question: L10n.howToUseQ6Title, answer: L10n.howToUseQ6Text)
                    AccordionBoxView(question: L10n.howToUseQ7Title, answer: L10n.howToUseQ7Text)
                }
            }.scrollContentBackground(.hidden)
                .background(rootEnvironment.state.scheme.foundationSub)
        }.background(rootEnvironment.state.scheme.foundationSub)
            .fontM()
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    FaqListView()
        .environment(\.rootEnvironment, DIContainer.shared.resolve(RootEnvironment.self))
}

private struct AccordionBoxView: View {
    let question: String
    let answer: String
    @State private var isClick: Bool = false

    var body: some View {
        HStack {
            Image(systemName: "questionmark")
                .opacity(0.5)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            Text(question)
                .fontS()

            Spacer()

            Button {
                withAnimation {
                    isClick.toggle()
                }
            } label: {
                Image(systemName: isClick ? "minus" : "plus")
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .opacity(0.8)
            }
        }
        if isClick {
            Text(answer)
                .fontS()
                .padding(.vertical)
                .padding(.leading)
        }
    }
}
