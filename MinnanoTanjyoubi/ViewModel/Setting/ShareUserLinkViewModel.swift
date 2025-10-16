//
//  ShareUserLinkViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import SwiftUI

@MainActor
final class ShareUserLinkViewModel: ObservableObject {
    
    @Published private(set) var allUsers: [User] = []
    @Published private(set) var shareUsers: [User] = []
    
    /// `Repository`
    private let localRepository: RealmRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        localRepository = repositoryDependency.realmRepository
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
    
    func shareUser() {
        ShareInfoUtillity.shareBirthday(shareUsers)
    }
    
    private func readAllUsers() {
        allUsers = localRepository.readAllObjs()
    }
}
