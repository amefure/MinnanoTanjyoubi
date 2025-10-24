//
//  ShareUserLinkViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import SwiftUI

final class ShareUserLinkViewModel: ObservableObject {
    @Published private(set) var allUsers: [User] = []
    @Published private(set) var shareUsers: [User] = []

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
        if shareUsers.contains(user) {
            shareUsers.removeAll(where: { $0.id == user.id })
        } else {
            shareUsers.append(user)
        }
    }

    @MainActor
    func shareUser() {
        ShareInfoUtillity.shareBirthday(shareUsers)
    }

    private func readAllUsers() {
        allUsers = localRepository.readAllObjs()
    }
}
