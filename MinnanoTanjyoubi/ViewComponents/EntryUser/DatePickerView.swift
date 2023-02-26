//
//  DatePickerView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/02.
//

import SwiftUI

struct DatePickerView: View {
    
    // MARK: - Models
    private var df: DateFormatter {
        let dateManager = DateManagerModel()
        dateManager.conversionJapanese()
        return dateManager.df
    }
   
    // MARK: - View
    @Binding var date:Date
    @State var dateStr:String = ""
    @Binding var isWheel:Bool
//    @State var isWheel:Bool = false
    

    // MARK: - Setting
    private let deviceWidth = DeviceSizeModel.deviceWidth
    private let deviceHeight = DeviceSizeModel.deviceHeight
    private let isSESize:Bool = DeviceSizeModel.isSESize
    
    var body: some View {
        
        HStack{
            
            if !isWheel {
                DatePicker(selection: $date,
                           displayedComponents: DatePickerComponents.date,
                           label: {
                    Text("誕生日")
                })
                .environment(\.locale, Locale(identifier: "ja_JP"))
                .environment(\.calendar, Calendar(identifier: .gregorian))
                .onChange(of: date) { newValue in
                    dateStr = df.string(from: newValue)
                }
                .frame(width: isSESize ? 170 :220)
                .datePickerStyle(.wheel)
                .labelsHidden()
                .scaleEffect(x: isSESize ? 0.8 : 0.9, y: isSESize ? 0.8 : 0.9)
            }else{
                Text(dateStr).frame(width: isSESize ? 170 :220)
            }
            
            Button(action: {
                isWheel.toggle()
            }, label: {
                Text(isWheel ? "変更" : "決定")
                    .padding(3)
                    .background(isWheel ? ColorAsset.themaColor2.thisColor : ColorAsset.themaColor3.thisColor).opacity(0.8)
                    .cornerRadius(5)
            }).padding([.leading,.top,.bottom])
            
            
        }
        .onAppear(){
            dateStr = df.string(from: Date())
        }
    }
}


