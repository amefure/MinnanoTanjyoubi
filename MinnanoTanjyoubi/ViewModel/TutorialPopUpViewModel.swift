//
//  TutorialPopUpViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/19.
//

import SwiftUI

struct TutorialPopUpState {
    var isPresented: Bool = false
    fileprivate(set) var title: String = ""
    fileprivate(set) var message: String = ""
    fileprivate(set) var buttonTitle: String = ""
    fileprivate(set) var buttonAction: () -> Void = {}
    fileprivate(set) var position: PopUpPosition = .bottomRight
}

@MainActor
final class TutorialPopUpViewModel: ObservableObject {
    @Published var state = TutorialPopUpState()

    private let repository: RealmRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        repository = repositoryDependency.realmRepository
        let users: [User] = repository.readAllObjs()
        if users.count == 0 {
            // チュートリアルを表示したことがないならチュートリアルを表示
            if !getShowTutorialFlag() {
                showPopUp(.bottomRight)
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
            showPopUp(.bottomRight)
        }
    }

    private func showPopUp(_ position: PopUpPosition?) {
        guard let position else { return }
        state.position = position
        setUpTitleMessage(position)
        state.isPresented = true
        state.buttonAction = { [weak self] in
            guard let self else { return }
            // 再帰的に処理を実行する
            self.showPopUp(state.position.next)
            // 最後まで確認したらフラグをONにして再度表示されないようにする
            guard position.next == nil else { return }
            self.setShowTutorialFlag()
        }
    }

    private func setUpTitleMessage(_ position: PopUpPosition) {
        switch position {
        case .topLeft:
            state.title = L10n.tutorialTopLeftTitle
            state.message = L10n.tutorialTopLeftMsg
            state.buttonTitle = L10n.tutorialTopLeftButton
        case .topRight:
            state.title = L10n.tutorialTopRightTitle
            state.message = L10n.tutorialTopRightMsg
            state.buttonTitle = L10n.tutorialNextButton
        case .bottomLeft:
            state.title = L10n.tutorialBottomLeftTitle
            state.message = L10n.tutorialBottomLeftMsg
            state.buttonTitle = L10n.tutorialNextButton
        case .bottomMiddle:
            state.title = L10n.tutorialBottomMiddleTitle
            state.message = L10n.tutorialBottomMiddleMsg
            state.buttonTitle = L10n.tutorialNextButton
        case .bottomRight:
            state.title = L10n.tutorialBottomRightTitle
            state.message = L10n.tutorialBottomRightMsg
            state.buttonTitle = L10n.tutorialNextButton
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
    private func setTutorialReShowFlag() {
        AppManager.sharedUserDefaultManager.setTutorialReShowFlag(false)
    }
}
