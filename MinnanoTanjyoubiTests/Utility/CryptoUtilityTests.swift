//
//  CryptoUtilityTests.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/19.
//
@testable import MinnanoTanjyoubi
import Testing
import XCTest

@Suite
struct CryptoUtilityTests {
    let crypto = CryptoUtillity()

    @Test
    func testEncryptionAndDecryption() {
        let originalText = "Hello, Swift暗号化123!🚀"

        let encryptedText = crypto.encryption(originalText)
        #expect(encryptedText != nil)

        let decryptedText = crypto.decryption(encryptedText!)
        #expect(decryptedText == originalText)
    }

    @Test
    func testDecryptionWithInvalidBase64() {
        let invalidCipherText = "ThisIsNotBase64EncodedString"
        let decrypted = crypto.decryption(invalidCipherText)
        #expect(decrypted == nil)
    }

    @Test
    func testEncryptionReturnsDifferentValuesForDifferentInputs() {
        let text1 = "SampleText1"
        let text2 = "SampleText2"

        let encrypted1 = crypto.encryption(text1)
        let encrypted2 = crypto.encryption(text2)

        #expect(encrypted1 != encrypted2)
    }

    @Test
    func testEncryptionIsDeterministic() {
        let text = "RepeatableText"

        let encrypted1 = crypto.encryption(text)
        let encrypted2 = crypto.encryption(text)

        #expect(encrypted1 == encrypted2)
    }
}
