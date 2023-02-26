//
//  DetailUserView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/10/01.
//

import SwiftUI
import RealmSwift

// MARK: - リストページからの詳細ページビュー

struct DetailUserView: View {
    
    // MARK: - Models
    @ObservedRealmObject var user:User
    
    // MARK: - View
    @State var isModal:Bool = false
    
    // MARK: - Setting
    private let deviceWidth = DeviceSizeModel.deviceWidth
    private let isSESize = DeviceSizeModel.isSESize
    
    
    var body: some View {
        VStack{
            
            UpSideView()
            
            Group{
                
                // MARK: - Relation/あと何日../名前/ふりがな/生年月日/和暦
                UpSideUserInfoView(user: user)
                
                // MARK: - 年齢/星座/干支
                MiddleUserInfoView(user: user)
                
                // MARK: - Memo
                ScrollView{
                    Text(user.memo).frame(width:deviceWidth - 40)
                }.padding(isSESize ? 5 : 10).frame(width:deviceWidth - 40).frame(maxHeight:80)
                    .overBorder(radius: 5, color: ColorAsset.foundationColorDark.thisColor, opacity: 0.4, lineWidth: 2)
                
                
            }.padding(isSESize ? 5 : 10)
            
            // MARK: - 通知ビュー
            NotificationButtonView(user: user)

            
            Spacer()
            
            DownSideView(parentFunction: {
                isModal = true
            }, imageString: "square.and.pencil")
            .sheet(isPresented: $isModal, content: {
                EntryUserView(user:user,isModal: $isModal)
            })
            
            // MARK: - AdMob
            AdMobBannerView().frame(height: 50)
            
        } .background(ColorAsset.foundationColorLight.thisColor)
            .foregroundColor(.white)
            .navigationBarBackButtonHidden(true)
            .navigationBarHidden(true)
        
    }
}


