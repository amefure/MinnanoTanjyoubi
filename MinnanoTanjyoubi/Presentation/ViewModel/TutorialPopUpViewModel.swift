//
//  TutorialPopUpViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/12/19.
//

import SwiftUI

@Observable
final class TutorialPopUpState {
    var isPresented: Bool = false
    fileprivate(set) var title: String = ""
    fileprivate(set) var message: String = ""
    fileprivate(set) var buttonTitle: String = ""
    fileprivate(set) var buttonAction: () -> Void = {}
    fileprivate(set) var position: PopUpPosition = .bottomRight
}

final class TutorialPopUpViewModel: ObservableObject {
    var state = TutorialPopUpState()

    /// `Repository`
    private let localRepository: RealmRepository
    private let userDefaultsRepository: UserDefaultsRepository

    init(
        localRepository: RealmRepository,
        userDefaultsRepository: UserDefaultsRepository
    ) {
        self.localRepository = localRepository
        self.userDefaultsRepository = userDefaultsRepository

        let users: [User] = localRepository.readAllObjs()
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
            showPopUp(state.position.next)
            // 最後まで確認したらフラグをONにして再度表示されないようにする
            guard position.next == nil else { return }
            setShowTutorialFlag()
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
        userDefaultsRepository.getShowTutorialFlag()
    }

    /// チュートリアル初回表示フラグセット
    private func setShowTutorialFlag() {
        userDefaultsRepository.setShowTutorialFlag(true)
    }

    /// チュートリアル再表示フラグ取得
    private func getTutorialReShowFlag() -> Bool {
        userDefaultsRepository.getTutorialReShowFlag()
    }

    /// チュートリアル再表示フラグセット
    private func setTutorialReShowFlag() {
        userDefaultsRepository.setTutorialReShowFlag(false)
    }
}
