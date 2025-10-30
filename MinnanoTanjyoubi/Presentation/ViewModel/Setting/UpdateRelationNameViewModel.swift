//
//  UpdateRelationNameViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/10/11.
//

import SwiftUI

@Observable
final class UpdateRelationNameState {
    var isShowSuccessAlert = false
    var isShowValidationAlert = false

    var friend: String = ""
    var family: String = ""
    var school: String = ""
    var work: String = ""
    var other: String = ""
    var sns: String = ""

    fileprivate func setRelationName(relationList: [String]) {
        friend = relationList[safe: 0] ?? RelationConfig.FRIEND_NAME
        family = relationList[safe: 1] ?? RelationConfig.FAMILY_NAME
        school = relationList[safe: 2] ?? RelationConfig.SCHOOL_NAME
        work = relationList[safe: 3] ?? RelationConfig.WORK_NAME
        other = relationList[safe: 4] ?? RelationConfig.OTHER_NAME
        sns = relationList[safe: 5] ?? RelationConfig.SNS_NAME
    }

    fileprivate func validationInput() -> Bool {
        let targetList = [friend, family, school, work, other, sns]
        return !targetList.contains(where: \.isEmpty)
    }
}

final class UpdateRelationNameViewModel {
    var state = UpdateRelationNameState()

    /// `Repository`
    private let userDefaultsRepository: UserDefaultsRepository

    init(userDefaultsRepository: UserDefaultsRepository) {
        self.userDefaultsRepository = userDefaultsRepository
    }

    func onAppear() {
        let relationList = userDefaultsRepository.getRelationNameList()
        state.setRelationName(relationList: relationList)
    }

    @MainActor
    func saveRelationName() {
        UIApplication.shared.closeKeyboard()

        guard state.validationInput() else {
            state.isShowValidationAlert = true
            return
        }
        userDefaultsRepository.setRelationName(key: .friend, value: state.friend)
        userDefaultsRepository.setRelationName(key: .family, value: state.family)
        userDefaultsRepository.setRelationName(key: .school, value: state.school)
        userDefaultsRepository.setRelationName(key: .work, value: state.work)
        userDefaultsRepository.setRelationName(key: .other, value: state.other)
        userDefaultsRepository.setRelationName(key: .sns, value: state.sns)
        state.isShowSuccessAlert = true
    }
}
