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
    func testEncodeToJsonString() {
        let json = jsonUtil.convertJson(user)
        #expect(json != nil)
        #expect(json!.contains("吉田　真紘"))
        #expect(json!.contains("よしだ　まひろ"))
    }

    @Test
    func testDecodeFromJsonString() {
        let json = """
        {
            "id": 2,
            "name": "吉田　真紘",
            "ruby": "よしだ　まひろ"
        }
        """
        let user: User? = jsonUtil.decode(json)
        #expect(user != nil)
        #expect(user?.id == 2)
        #expect(user?.name == "吉田　真紘")
    }

    @Test
    func testRoundTripEncodeDecode() {
        let json = jsonUtil.convertJson(user)
        #expect(json != nil)

        let decoded: User? = jsonUtil.decode(json!)
        #expect(decoded != nil)
        #expect(decoded == user)
    }

    @Test
    func testInvalidJsonReturnsNil() {
        let invalidJson = "{ invalid json }"
        let decoded: User? = jsonUtil.decode(invalidJson)
        #expect(decoded == nil)
    }
}
