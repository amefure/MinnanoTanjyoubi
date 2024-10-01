//
//  FaqListView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/10/01.
//

import SwiftUI

struct FaqListView: View {
    @EnvironmentObject private var rootEnvironment: RootEnvironment
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack {
            UpSideView()
                .environmentObject(rootEnvironment)

            Text("よくある質問")
                .font(.system(size: 20))
                .foregroundStyle(AppColorScheme.getText(rootEnvironment.scheme))
                .fontWeight(.bold)
                .padding(.vertical)

            List {
                Section {
                    AccordionBoxView(question: L10n.howToUseQ1Title, answer: L10n.howToUseQ1Text)
                    AccordionBoxView(question: L10n.howToUseQ2Title, answer: L10n.howToUseQ2Text)
                    AccordionBoxView(question: L10n.howToUseQ3Title, answer: L10n.howToUseQ3Text)
                    AccordionBoxView(question: L10n.howToUseQ4Title, answer: L10n.howToUseQ4Text)
//                    AccordionBoxView(question: L10n.howToUseQ5Title, answer: L10n.howToUseQ5Text)
//                    AccordionBoxView(question: L10n.howToUseQ6Title, answer: L10n.howToUseQ6Text)
//                    AccordionBoxView(question: L10n.howToUseQ7Title, answer: L10n.howToUseQ7Text)
                }
            }.scrollContentBackground(.hidden)
                .background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
        }.background(AppColorScheme.getFoundationSub(rootEnvironment.scheme))
            .font(.system(size: 17))
            .navigationBarBackButtonHidden()
    }
}

#Preview {
    FaqListView()
}

struct AccordionBoxView: View {
    public let question: String
    public let answer: String
    @State private var isClick: Bool = false

    var body: some View {
        HStack {
            Image(systemName: "questionmark")
                .opacity(0.5)
                .fontWeight(.bold)
                .foregroundColor(.gray)

            Text(question)
                .font(.system(size: 15))

            Spacer()

            Button {
                isClick.toggle()
            } label: {
                Image(systemName: isClick ? "minus" : "plus")
                    .foregroundColor(.gray)
                    .fontWeight(.bold)
                    .opacity(0.8)
            }
        }
        if isClick {
            Text(answer)
                .font(.system(size: 13))
                .padding(.vertical)
                .padding(.leading)
        }
    }
}
