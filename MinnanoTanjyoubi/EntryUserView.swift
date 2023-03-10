//
//  EntryUserView.swift
//  Pods
//
//  Created by t&a on 2022/09/30.
//

import SwiftUI
import RealmSwift

// MARK: - モーダル表示されるデータ登録ビュー
// データ更新時も呼び出される

struct EntryUserView: View {
    
    // MARK: - Models
    @ObservedResults(User.self) var users
    // Updateデータ受け取り用
    public var user:User?
    
    // MARK: - Controller
    private let realmCrudManager = RealmCrudManager()
    
    // MARK: - Setting
    private let isSESize:Bool = DeviceSizeModel.isSESize
    
    // MARK: - Input View
    @State var name:String = ""
    @State var ruby:String = ""
    @State var date:Date = Date()
    @State var memo:String = ""
    @State var selectedRelation:Relation = .other
    
    // MARK: - View  Control
    @Binding var isModal:Bool            // 自信の表示モーダルフラグ
    @State var isWheel:Bool = false      // カレンダーON/OFF
    @FocusState var isFocusActive:Bool   // TextField/TextEditor ActiveFlag
    
    // MARK: - バリデーション
    private func validationInput() -> Bool{
        if name == "" {
            return false
        }
        return true
    }
    
    var body: some View {
        
        
        VStack(alignment: .center){
            
            // MARK: - ViewComponent
            UpSideView()
            
            Spacer()
            
            VStack(spacing: isSESize ? 5 :20){
                
                
                // Input Name
                HStack{
                    Text("名　　前").frame(width: 80)
                    TextField("名前", text: $name)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.primary)
                        .focused($isFocusActive)
                }.padding(5)
                
                // Input Ruby
                HStack{
                    Text("ふりがな").frame(width: 80)
                    TextField("ふりがな", text: $ruby)
                        .textFieldStyle(.roundedBorder)
                        .foregroundColor(.primary)
                        .focused($isFocusActive)
                }.padding(5)
                
                // Input Date
                HStack{
                    Text("生年月日").frame(width: 80)
                    Spacer()
                    DatePickerView(date: $date,isWheel: $isWheel)
                }.padding(5)
                
                // Input Relation
                HStack{
                    Text("関　　係").frame(width: 80)
                    Spacer()
                    RelationPickerView(selectedRelation: $selectedRelation)
                    Spacer()
                }.padding(5)
                
                // Input Relation
                Group{
                    
                    Text("MEMO").foregroundColor(ColorAsset.foundationColorDark.thisColor).fontWeight(.bold).opacity(0.8)
                    
                    TextEditor(text: $memo)
                        .background(ColorAsset.foundationColorLight.thisColor)
                        .padding(5)
                        .overBorder(radius: 5, color: ColorAsset.foundationColorDark.thisColor, opacity: 0.4, lineWidth: 3)
                        .frame(maxHeight: 90)
                        .frame(minHeight: 70)
                        .focused($isFocusActive)
                        .scrollContentBackground(.hidden)
                }
                
            }
            
            Spacer()
            
            // MARK: - ViewComponent
            DownSideView(parentFunction: {
                if validationInput(){
                    
                    if user == nil { // Update??
                        // NO
                        realmCrudManager.createUser(name: name, ruby: ruby, date: date, relation: selectedRelation, memo: memo)
                    }else{
                        // Yes
                        realmCrudManager.updateUser(user: user!, name: name, ruby: ruby, date: date, relation: selectedRelation, memo: memo)
                    }
                    
                    isModal = false
                    
                } // validationInput
            }, imageString: "checkmark")
            
            
        }.padding()
            .background(ColorAsset.foundationColorLight.thisColor)
            .foregroundColor(.white)
            .onAppear(){
                // Update時なら初期値セット
                if user != nil{
                    name = user!.name
                    ruby = user!.ruby
                    date = user!.date
                    selectedRelation = user!.relation
                    memo = user!.memo
                }
            }
            .onChange(of: isFocusActive, perform: { newValue in
                if isFocusActive {
                    isWheel = true
                }
            })
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()         // 右寄せにする
                    Button("閉じる") {
                        isFocusActive = false  //  フォーカスを外す
                    }
                }
            }
    }
}

