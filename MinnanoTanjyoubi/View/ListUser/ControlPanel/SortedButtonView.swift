//
//  SortedButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import SwiftUI

struct SortedButtonView: View {
    // MARK: - View

    @State private var isPicker: Bool = false
    @State private var isSorted: Bool = false
    @State private var selectedRelation: Relation = .other

    // MARK: - ViewModel

    @ObservedObject private var repository = RealmRepositoryViewModel.shared
    @ObservedObject private var rootEnvironment = RootEnvironment.shared

    var body: some View {
        Button {
            if isSorted {
                isSorted = false
                repository.readAllUsers()
            } else {
                isPicker.toggle()
                isSorted = true
            }
        } label: {
            Image(systemName: "person.2.crop.square.stack")
                .circleBorderView(width: 50, height: 50, color: ColorAsset.themaColor4.thisColor)
                .foregroundColor(isSorted ? ColorAsset.themaColor2.thisColor : .white)
        }
        .onChange(of: selectedRelation) { newValue in
            repository.filteringUser(selectedRelation: newValue)
        }
        .sheet(isPresented: $isPicker) {
            VStack {
                Picker(selection: $selectedRelation) {
                    ForEach(Array(rootEnvironment.relationNameList.enumerated()), id: \.element) { index, item in
                        Text(item).tag(Relation.getIndexbyRelation(index))
                    }
                } label: {}.pickerStyle(.segmented)
                    .presentationDetents([.height(100)])
            }
        }
    }
}
