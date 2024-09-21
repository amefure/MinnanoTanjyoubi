//
//  RelationPickerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/02.
//

import SwiftUI

struct RelationPickerView: View {
    @Binding var selectedRelation: Relation
    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    var body: some View {
        Picker(selection: $selectedRelation, label: Text("関係")) {
            ForEach(Array(rootEnvironment.relationNameList.enumerated()), id: \.element) { index, item in
                Text(item)
                    .tag(Relation.getIndexbyRelation(index))
            }
        }.pickerStyle(.menu)
            .overlay(
                RoundedRectangle(cornerRadius: 5)
                    .stroke(AppColorScheme.getText().opacity(0.4), lineWidth: 2)
            ).tint(AppColorScheme.getText())
    }
}

struct RelationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RelationPickerView(selectedRelation: Binding.constant(.other))
    }
}
