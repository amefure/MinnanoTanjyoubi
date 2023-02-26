//
//  HeaderView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2023/02/12.
//

import SwiftUI


struct HeaderView: View {
    
    // MARK: - Modal Control 設定画面遷移
    @Binding var isSettingActive:Bool
    
    // MARK: - Setting
    private let deviceWidth = DeviceSizeModel.deviceWidth
    private let isSESize = DeviceSizeModel.isSESize
    
    var body: some View {
        
        HStack(alignment: .center){
            ZStack{
                
                Image("Appicon-remove").resizable()
                    .frame(width: isSESize ? 55 : 70 , height: isSESize ? 55 : 70)
                
                Button(action: {
                    isSettingActive = true
                }, label: {
                    Image(systemName: "gearshape.fill")
                }).foregroundColor(.white).position(x:deviceWidth - 30,y:30)
            }
        }.frame(width:deviceWidth,height: isSESize ? 80 : 90).background(ColorAsset.foundationColorDark.thisColor)
    }
}

struct HeaderView_Previews: PreviewProvider {
    static var previews: some View {
        HeaderView(isSettingActive:Binding.constant(true))
    }
}
