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
    @Published private(set) var popupButtonAction: () -> Void = {}
    @Published private(set) var position: PopUpPosition = .bottomRight

    private let repository = RealmRepository()

    private let userDefaultsRepository: UserDefaultsRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
        let count = repository.readAllUsers().count
        if count == 0 {
            // チュートリアルを表示したことがないならチュートリアルを表示
            if !getShowTutorialFlag() {
                showPopUp()
            }
        } else {
            // データが既にあるならチュートリアルは表示しない かつ　フラグを済みにする
            setShowTutorialFlag()
        }
    }

    public func onAppear() {
        // 再表示フラグがONならチュートリアル開始
        if getTutorialReShowFlag() {
            // 再表示フラグをOFFに
            setTutorialReShowFlag()
            showPopUp()
        }
    }

    private func showPopUp(_ position: PopUpPosition? = .bottomRight) {
        guard let position else { return }
        self.position = position
        setUpTitleMessage(position)
        show = true
        popupButtonAction = {
            // 再帰的に処理を実行する
            self.showPopUp(position.next)
            // 最後まで確認したらフラグをONにして再度表示されないようにする
            if position.next == nil {
                self.setShowTutorialFlag()
            }
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
            message = "通知時間やメッセージ、アプリのロック、テーマカラーの変更、関係性名の変更、容量の追加など自分の好きなようにアプリをカスタマイズすることができます。"
            buttonTitle = "NEXT"
        case .bottomLeft:
            title = "誕生日情報を削除できるよ！"
            message = "このボタンをタップすることで「削除モード」に切り替わります。\n削除したい誕生日情報を選択できるようになるので選んだ後に再度このボタンをタップすることで削除することができます。"
            buttonTitle = "NEXT"
        case .bottomMiddle:
            title = "誕生日情報をフィルタリング！"
            message = "このボタンをタップすることで設定した関係性ごとに誕生日情報をフィルタリングすることができます。"
            buttonTitle = "NEXT"
        case .bottomRight:
            title = "誕生日情報を登録をしよう！"
            message = "このボタンをタップすることで友達や家族の誕生日情報を入力して登録することができます。\n登録した誕生日情報は一覧として表示されるよ。"
            buttonTitle = "NEXT"
        }
    }
}

extension TutorialPopUpViewModel {
    /// チュートリアル初回表示フラグ取得
    private func getShowTutorialFlag() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.TUTORIAL_SHOW_FLAG)
    }

    /// チュートリアル初回表示フラグセット
    private func setShowTutorialFlag() {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.TUTORIAL_SHOW_FLAG, isOn: true)
    }

    /// チュートリアル再表示フラグ取得
    private func getTutorialReShowFlag() -> Bool {
        userDefaultsRepository.getBoolData(key: UserDefaultsKey.TUTORIAL_RE_SHOW_FLAG)
    }

    /// チュートリアル再表示フラグセット
    public func setTutorialReShowFlag() {
        userDefaultsRepository.setBoolData(key: UserDefaultsKey.TUTORIAL_RE_SHOW_FLAG, isOn: false)
    }
}
