//
//  NotificationButtonView.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2022/12/22.
//

import SwiftUI

// MARK: - 通知登録ビュー
struct NotificationButtonView: View {
    
    // MARK: - Models
    @State var user:User
    
    // MARK: - Controller
    private let notificationRequestManager = NotificationRequestManager()
    
    // MARK: - View
    @State var isON:Bool = false
    
    // MARK: - Setting
    private let deviceWidth = DeviceSizeModel.deviceWidth
    private let isSESize = DeviceSizeModel.isSESize
    
    var body: some View {
        
        
        Toggle(isOn: $isON, label: {
            Text("通知")
        }).toggleStyle(SwitchToggleStyle(tint:ColorAsset.themaColor1.thisColor))
            .onChange(of: isON) { newValue in
                if newValue {
                    // 通知を登録
                    let df = DateFormatter()
                    df.dateFormat = "yyyy-MM-dd-H-m"
                    let dateString = df.string(from: user.date)
                    notificationRequestManager.sendNotificationRequest(user.id,user.name,dateString)

                    // データベース更新
                    let thawUser = user.thaw()
                    try! thawUser?.realm!.write{
                        thawUser?.alert = true
                    }
                }else{
                    // 通知を削除
                    notificationRequestManager.removeNotificationRequest(user.id,user.name)
                    // データベース更新
                    let thawUser = user.thaw()
                    try! thawUser?.realm!.write{
                        thawUser?.alert = false
                    }
                }
            }.frame(width:deviceWidth - 60).padding(isSESize ? 5 : 10)
            .onAppear(){
                // 初期値セット
                isON = user.alert
            }
    }
}
