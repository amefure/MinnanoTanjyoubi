//
//  SortedButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import SwiftUI

struct SortedButtonView: View {
    // MARK: - View

    @State var isPicker: Bool = false
    @Binding var isSorted: Bool
    @Binding var selectedRelation: Relation

    var body: some View {
        Button {
            if isSorted {
                isSorted = false
            } else {
                isPicker.toggle()
                isSorted = true
            }

        } label: {
            Image(systemName: "person.2.crop.square.stack")

                .circleBorderView(width: 50, height: 50, color: ColorAsset.themaColor4.thisColor)
                .foregroundColor(isSorted ? ColorAsset.themaColor2.thisColor : .white)

        }.sheet(isPresented: $isPicker) {
            // MARK: - EntryButton

            VStack {
                Picker(selection: $selectedRelation) {
                    ForEach(Relation.allCases, id: \.self) { item in
                        Text(item.rawValue)
                    }
                } label: {}.pickerStyle(.wheel)
                    .presentationDetents([.height(100)])
            }
        }
    }
}
