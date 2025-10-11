//
//  UpdateRelationNameViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import SwiftUI

@MainActor
final class UpdateRelationNameViewModel: ObservableObject {
    
    @Published var isShowSuccessAlert = false
    @Published var isShowValidationAlert = false
    
    @Published var friend: String = ""
    @Published var family: String = ""
    @Published var school: String = ""
    @Published var work: String = ""
    @Published var other: String = ""
    @Published var sns: String = ""
    
    /// `Repository`
    private let userDefaultsRepository: UserDefaultsRepository

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
    }
    
    func onAppear(relationList: [String]) {
        friend = relationList[safe: 0] ?? RelationConfig.FRIEND_NAME
        family = relationList[safe: 1] ?? RelationConfig.FAMILY_NAME
        school = relationList[safe: 2] ?? RelationConfig.SCHOOL_NAME
        work = relationList[safe: 3] ?? RelationConfig.WORK_NAME
        other = relationList[safe: 4] ?? RelationConfig.OTHER_NAME
        sns = relationList[safe: 5] ?? RelationConfig.SNS_NAME
    }
    
    private func validationInput() -> Bool {
        let targetList = [friend, family, school, work, other, sns]
        return !targetList.contains(where: { $0.isEmpty })
    }

    func saveRelationName() {
        UIApplication.shared.closeKeyboard()

        guard validationInput() else {
            isShowValidationAlert = true
            return
        }
        setRelationName(key: UserDefaultsKey.DISPLAY_RELATION_FRIEND, value: friend)
        setRelationName(key: UserDefaultsKey.DISPLAY_RELATION_FAMILY, value: family)
        setRelationName(key: UserDefaultsKey.DISPLAY_RELATION_SCHOOL, value: school)
        setRelationName(key: UserDefaultsKey.DISPLAY_RELATION_WORK, value: work)
        setRelationName(key: UserDefaultsKey.DISPLAY_RELATION_OTHER, value: other)
        setRelationName(key: UserDefaultsKey.DISPLAY_RELATION_SNS, value: sns)
        isShowSuccessAlert = true
    }

    private func setRelationName(key: String, value: String) {
        userDefaultsRepository.setStringData(key: key, value: value)
    }
}
