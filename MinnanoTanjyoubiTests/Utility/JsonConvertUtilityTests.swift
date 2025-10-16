//
//  JsonConvertUtilityTests.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/19.
//
@testable import MinnanoTanjyoubi
import Testing
import XCTest

@Suite
struct JsonConvertUtilityTests {
    private let jsonUtil = JsonConvertUtility()

    private let user = User.createDemoUser(
        name: "吉田　真紘",
        ruby: "よしだ　まひろ",
        dateStr: "1994年12月21日",
        relation: .friend
    )

    @Test
    func encodeToJsonString() {
        let json = jsonUtil.convertJson(user)
        #expect(json != nil)
        #expect(json!.contains("吉田　真紘"))
        #expect(json!.contains("よしだ　まひろ"))
    }

    @Test
    func decodeFromJsonString() {
        let json = """
        {
            "date": -190371600,
            "memo": "",
            "alert": false,
            "isYearsUnknown": false,
            "ruby": "よしだ　まひろ",
            "relation": "友達",
            "id": "68f0f5faef0542b1372f44c7",
            "name": "吉田　真紘"
        }
        """
        let user: User? = jsonUtil.decode(json)
        #expect(user != nil)
        #expect(user?.id.stringValue == "68f0f5faef0542b1372f44c7")
        #expect(user?.name == "吉田　真紘")
    }

    @Test
    func roundTripEncodeDecode() {
        let json = jsonUtil.convertJson(user)
        #expect(json != nil)

        let decoded: User? = jsonUtil.decode(json!)
        #expect(decoded != nil)
        #expect(decoded?.id == user.id)
    }

    @Test
    func invalidJsonReturnsNil() {
        let invalidJson = "{ invalid json }"
        let decoded: User? = jsonUtil.decode(invalidJson)
        #expect(decoded == nil)
    }
}
