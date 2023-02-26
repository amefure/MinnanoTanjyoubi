//
//  RelationPickerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/02.
//

import SwiftUI

struct RelationPickerView: View {
    
    @Binding var selectedRelation:Relation
    
    var body: some View {
        Picker(selection: $selectedRelation, label: Text("関係")) {
              ForEach(Relation.allCases, id: \.self) { item in
                  Text(item.rawValue)
              }
        }.pickerStyle(.menu)
            .frame(width: 100)
            .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(ColorAsset.foundationColorDark.thisColor.opacity(0.4), lineWidth: 2)
            ).tint(ColorAsset.foundationColorDark.thisColor)
    }
}

struct RelationPickerView_Previews: PreviewProvider {
    static var previews: some View {
        RelationPickerView(selectedRelation: Binding.constant(.other))
    }
}
