//
//  DateFormatUtilityTests.swift
//  MinnanoTanjyoubi
//
//  Created by t&a on 2025/06/07.
//

@testable import MinnanoTanjyoubi
import Testing
import XCTest

@Suite
struct DateFormatUtilityTests {
    let formatter = DateFormatUtility()
    let testDate: Date = {
        var components = DateComponents()
        components.year = 2024
        components.month = 6
        components.day = 5
        components.hour = 14
        components.minute = 30
        components.second = 0
        return Calendar(identifier: .gregorian).date(from: components)!
    }()

    @Test
    func testGetSlashString() {
        let result = formatter.getSlashString(date: testDate)
        #expect(result == "2024/06/05")
    }

    @Test
    func testGetJpString() {
        let result = formatter.getJpString(date: testDate)
        #expect(result == "2024年6月5日")
    }

    @Test
    func testGetJpStringOnlyDate() {
        let result = formatter.getJpStringOnlyDate(date: testDate)
        #expect(result == "6月5日")
    }

    @Test
    func testGetJpEraString() {
        let result = formatter.getJpEraString(date: testDate)
        #expect(result.contains("令和") || result.contains("平成"))
    }

    @Test
    func getNotifyStringAndBack() {
        let string = formatter.getNotifyString(date: testDate)
        let resultDate = formatter.getNotifyDate(from: string)
        let reconverted = formatter.getNotifyString(date: resultDate)
        #expect(string == reconverted)
    }

    @Test
    func testGetSlashDate() {
        let dateString = "2024/06/05"
        let date = formatter.getSlashDate(from: dateString)
        #expect(date != nil)
        #expect(formatter.getSlashString(date: date!) == dateString)
    }

    @Test
    func testGetJpDate() {
        let dateString = "2024年6月5日"
        let result = formatter.getJpDate(from: dateString)
        #expect(formatter.getJpString(date: result) == dateString)
    }

    @Test
    func testGetTimeString() {
        let result = formatter.getTimeString(date: testDate)
        #expect(result == "14-30")
    }

    @Test
    func testGetMonthInt() {
        let result = formatter.getMonthInt(date: testDate)
        #expect(result == 6)
    }

    @Test
    func testConvertDateComponents() {
        let components = formatter.convertDateComponents(date: testDate)
        #expect(components.year == 2024)
        #expect(components.month == 6)
        #expect(components.day == 5)
    }

    @Test
    func setYearDate() {
        let newDate = formatter.setDate(year: 2030)
        let year = Calendar(identifier: .gregorian).component(.year, from: newDate)
        #expect(year == 2030)
    }
}
