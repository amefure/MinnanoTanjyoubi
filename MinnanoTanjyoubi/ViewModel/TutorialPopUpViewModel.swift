//
//  TutorialPopUpViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/19.
//

import SwiftUI

class TutorialPopUpViewModel: ObservableObject {
    
    @Published var show: Bool = false
    @Published private(set) var title: String = ""
    @Published private(set) var message: String = ""
    @Published private(set) var buttonTitle: String = ""
    @Published private(set) var popupButtonAction: () -> Void = { }
    @Published private(set) var position: PopUpPosition = .bottomRight
    
    
    public func showPopUp(_ position: PopUpPosition? = .bottomRight) {
        guard let position else { return }
        self.position = position
        setUpTitleMessage(position)
        show = true
        popupButtonAction = {
            self.showPopUp(position.next)
        }
    }
    
    private func setUpTitleMessage(_ position: PopUpPosition) {
        switch position {
        case .topLeft:
            title = "レイアウトを変更できるよ！"
            message = "単純なグリッドレイアウトではなく関係性ごとにセクション分けされたレイアウトに切り替えることができます。"
            buttonTitle = "アプリをはじめよう！"
        case .topRight:
            title = "通知やアプリのカスタマイズ！"
            message = "通知時間やメッセージ、アプリのロック、テーマカラーの変更など自分の好きなようにアプリをカスタマイズすることができます。"
            buttonTitle = "NEXT"
        case .bottomLeft:
            title = "誕生日情報を削除できるよ！"
            message = "このボタンをタップすることで「削除モード」に切り替わります。\n削除したい誕生日情報を選択できるようになるので選んだ後に再度このボタンをタップすることで削除することができます。"
            buttonTitle = "NEXT"
        case .bottomMiddle:
            title = "誕生日情報をフィルタリング！"
            message = "このボタンをタップすることで関係性ごとに誕生日情報をフィルタリングすることができます。"
            buttonTitle = "NEXT"
        case .bottomRight:
            title = "誕生日情報を登録をしよう！"
            message = "このボタンをタップすることで友達や家族の誕生日情報を入力して登録することができます。\n登録した誕生日情報は一覧として表示されるよ"
            buttonTitle = "NEXT"
        }
    }
}
