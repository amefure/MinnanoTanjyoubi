//
//  MinnanoTanjyoubiTests.swift
//  MinnanoTanjyoubiTests
//
//  Created by t&a on 2025/05/17.
//

import Testing

@Suite
struct MinnanoTanjyoubiTests {
    static let allTests = [
        UserTest.self,
        DateFormatUtilityTests.self,
        CryptoUtilityTests.self,
        JsonConvertUtilityTests.self,
    ] as [Any]
}
