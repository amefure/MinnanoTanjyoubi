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

    private let repository: RealmRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.realmRepository
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

    func onAppear() {
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
            title = L10n.tutorialTopLeftTitle
            message = L10n.tutorialTopLeftMsg
            buttonTitle = L10n.tutorialTopLeftButton
        case .topRight:
            title = L10n.tutorialTopRightTitle
            message = L10n.tutorialTopRightMsg
            buttonTitle = L10n.tutorialNextButton
        case .bottomLeft:
            title = L10n.tutorialBottomLeftTitle
            message = L10n.tutorialBottomLeftMsg
            buttonTitle = L10n.tutorialNextButton
        case .bottomMiddle:
            title = L10n.tutorialBottomMiddleTitle
            message = L10n.tutorialBottomMiddleMsg
            buttonTitle = L10n.tutorialNextButton
        case .bottomRight:
            title = L10n.tutorialBottomRightTitle
            message = L10n.tutorialBottomRightMsg
            buttonTitle = L10n.tutorialNextButton
        }
    }
}

extension TutorialPopUpViewModel {
    /// チュートリアル初回表示フラグ取得
    private func getShowTutorialFlag() -> Bool {
        AppManager.sharedUserDefaultManager.getShowTutorialFlag()
    }

    /// チュートリアル初回表示フラグセット
    private func setShowTutorialFlag() {
        AppManager.sharedUserDefaultManager.setShowTutorialFlag(true)
    }

    /// チュートリアル再表示フラグ取得
    private func getTutorialReShowFlag() -> Bool {
        AppManager.sharedUserDefaultManager.getTutorialReShowFlag()
    }

    /// チュートリアル再表示フラグセット
    func setTutorialReShowFlag() {
        AppManager.sharedUserDefaultManager.setTutorialReShowFlag(false)
    }
}
