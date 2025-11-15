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
    func getSlashString() {
        let formatter = DateFormatUtility(format: .slash)
        let result = formatter.getString(date: testDate)
        #expect(result == "2024/06/05")
    }

    @Test
    func getJpString() {
        let formatter = DateFormatUtility(format: .jp)
        let result = formatter.getString(date: testDate)
        #expect(result == "2024年6月5日")
    }

    @Test
    func getJpStringOnlyDate() {
        let formatter = DateFormatUtility(format: .jpOnlyDate)
        let result = formatter.getString(date: testDate)
        #expect(result == "6月5日")
    }

    @Test
    func getJpEraString() {
        let formatter = DateFormatUtility(format: .jpEra)
        let result = formatter.getString(date: testDate)
        #expect(result.contains("令和") || result.contains("平成"))
    }

    @Test
    func getNotifyStringAndBack() {
        let dfm = DateFormatUtility(format: .hyphen)
        let string = dfm.getString(date: testDate)
        let resultDate = dfm.getDateNotNull(from: string)
        let reconverted = dfm.getString(date: resultDate)
        #expect(string == reconverted)
    }

    @Test
    func getSlashDate() {
        let dfm = DateFormatUtility(format: .slash)
        let dateString = "2024/06/05"
        let date = dfm.getDate(from: dateString)
        #expect(date != nil)
        #expect(dfm.getString(date: date!) == dateString)
    }

    @Test
    func getJpDate() {
        let dfm = DateFormatUtility(format: .jp)
        let dateString = "2024年6月5日"
        let result = dfm.getDateNotNull(from: dateString)
        #expect(dfm.getString(date: result) == dateString)
    }

    @Test
    func getTimeString() {
        let dfm = DateFormatUtility(format: .time)
        let result = dfm.getString(date: testDate)
        #expect(result.contains("14") && result.contains("30"))
    }

    @Test
    func testGetMonthInt() {
        let dfm = DateFormatUtility(format: .monthOnly)
        let result: Int = dfm.getMonthInt(date: testDate)
        #expect(result == 6)
    }

    @Test
    func testConvertDateComponents() {
        let dfm = DateFormatUtility()
        let components = dfm.convertDateComponents(date: testDate)
        #expect(components.year == 2024)
        #expect(components.month == 6)
        #expect(components.day == 5)
    }

    @Test
    func setYearDate() {
        let dfm = DateFormatUtility()
        let newDate = dfm.setDate(year: 2030)
        let year = Calendar(identifier: .gregorian).component(.year, from: newDate)
        #expect(year == 2030)
    }
}
