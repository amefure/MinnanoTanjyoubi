//
//  ShareUserLinkViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import SwiftUI

@Observable
final class ShareUserLinkState {
    fileprivate(set) var allUsers: [User] = []
    fileprivate(set) var shareUsers: [User] = []
}

final class ShareUserLinkViewModel {
    private(set) var state = ShareUserLinkState()

    /// `Repository`
    private let localRepository: RealmRepository

    init(localRepository: RealmRepository) {
        self.localRepository = localRepository
    }

    func onAppear() {
        readAllUsers()
        FBAnalyticsManager.loggingScreen(screen: .ShareUserLinkScreen)
    }

    func addOrDeleteShareUser(_ user: User) {
        if state.shareUsers.contains(user) {
            state.shareUsers.removeAll(where: { $0.id == user.id })
        } else {
            state.shareUsers.append(user)
        }
    }

    @MainActor
    func shareUser() {
        ShareInfoUtillity.shareBirthday(state.shareUsers)
    }

    private func readAllUsers() {
        state.allUsers = localRepository.readAllObjs().sorted { $0.name < $1.name }
    }
}
