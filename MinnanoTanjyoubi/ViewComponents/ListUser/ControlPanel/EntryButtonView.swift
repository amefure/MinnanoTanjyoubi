//
//  EntryButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/23.
//

import SwiftUI
import RealmSwift

struct EntryButtonView: View {
    
    // MARK: - Models
    @ObservedResults(User.self) var users
    
    // Storage
    @AppStorage("LimitCapacity") var limitCapacity = 5 // 初期値
    // MARK: - View  Control
    @State var isLimitAlert:Bool = false // 上限に達した場合のアラート
    
    // MARK: - View
    @State var isModal:Bool = false
    
    private func checkLimitCapacity() -> Bool{
        if users.count >= limitCapacity{
            isLimitAlert = true
            return false
        }else{
            return true
        }
    }
    
    var body: some View {
        Button(action: {
            if checkLimitCapacity() {
                isModal.toggle()
            }
            
        }, label: {
            Image(systemName: "plus")
        })
        .circleBorderView(width: 50, height: 50, color: ColorAsset.themaColor3.thisColor)
        .sheet(isPresented: $isModal, content: {
            EntryUserView(user:nil,isModal: $isModal)
        })
        .alert(Text("保存容量が上限に達しました..."),
               isPresented: $isLimitAlert,
               actions: {
            Button(action: {}, label: {
                Text("OK")
            })
        }, message: {
            Text("設定から広告を視聴すると\n保存容量を増やすことができます。" )
        })
    }
}

struct EntryButtonView_Previews: PreviewProvider {
    static var previews: some View {
        EntryButtonView()
    }
}
