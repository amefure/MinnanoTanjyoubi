//
//  BirthDayWidgetViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/09/09.
//

final class BirthDayWidgetViewModel {
    private let realmRepository = RealmRepository()

    func getNearBirthDayUser(
        users: [User],
        size: Int
    ) -> [User] {
        let result = Array(users).sorted(by: {
            UserCalcUtility.daysLater(from: $0.date) < UserCalcUtility.daysLater(from: $1.date)
        })
        return Array(result.prefix(size))
    }

    func getAllUser() -> [User] {
        return Array(realmRepository.readAllUsers())
    }
}
