//
//  EntryUserViewModel.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2024/06/18.
//

import UIKit

class EntryUserViewModel {
    private let userDefaultsRepository: UserDefaultsRepository

    private let dateFormatUtility = DateFormatUtility()

    init(repositoryDependency: RepositoryDependency = RepositoryDependency()) {
        userDefaultsRepository = repositoryDependency.userDefaultsRepository
    }

    /// バリデーション
    public func validationInput(_ name: String) -> Bool {
        return name != ""
    }

    public func getNewUser(
        name: String,
        ruby: String,
        date: Date,
        selectedRelation: Relation,
        memo: String,
        alert: Bool
    ) -> User {
        let newUser = User()
        newUser.name = name
        newUser.ruby = ruby
        newUser.date = date
        newUser.relation = selectedRelation
        newUser.memo = memo
        newUser.alert = alert
        return newUser
    }

    /// 保存された年数のDateオブジェクトを取得
    public func getInitYearDate() -> Date {
        let year = getEntryInitYear()
        let yearDate = dateFormatUtility.setYearDate(year: year)
        return yearDate
    }

    /// 年数初期値取得
    private func getEntryInitYear() -> Int {
        var year = userDefaultsRepository.getIntData(key: UserDefaultsKey.ENTRY_INTI_YEAR)
        if year == 0 {
            guard let nowYear = dateFormatUtility.convertDateComponents(date: Date()).year else { return 2024 }
            year = nowYear
        }
        return year
    }
}
