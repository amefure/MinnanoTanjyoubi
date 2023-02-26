//
//  ControlPanelView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/19.
//

import SwiftUI
import RealmSwift

// MARK: - リスト画面下部に表示するコントロールパネルビュー
struct ControlPanelView: View {
    
    
    // MARK: - View
    @Binding var isSorted:Bool
    @Binding var isDeleteMode:Bool
    @Binding var deleteIdArray:Array<ObjectId>
    @Binding var selectedRelation:Relation 

    // MARK: - Setting
    private let deviceWidth = DeviceSizeModel.deviceWidth
    
    var body: some View {
        HStack{
            
            Spacer()
            
            // MARK: - RemoveButton
            RemoveButtonView(isDeleteMode: $isDeleteMode, deleteIdArray: $deleteIdArray)
              
            
            Spacer()
            
            // MARK: - SortedButton
            SortedButtonView(isSorted: $isSorted, selectedRelation: $selectedRelation)
            
            Spacer()
            
            // MARK: - EntryButton
            EntryButtonView()
            
            Spacer()
            
        }.frame(width: deviceWidth ,height: 70)
            .foregroundColor(.white)
            .background(ColorAsset.foundationColorDark.thisColor)
            
    }
}


