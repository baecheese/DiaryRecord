//
//  DiaryRecordTests.swift
//  DiaryRecordTests
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import XCTest
@testable import DiaryRecord

class DiaryRecordTests: XCTestCase {
    
    let log = Logger(logPlace: DiaryRecordTests.self)
    
    func testLogger() {
        let testDiary = DiaryRepository.sharedInstance.findOne(id: 6)
        log.debug(message: testDiary)
        
        
        
        
        
    }
    
    func testTimeIntervalNow() {
        let ti = TimeInterval().now()
        log.debug(message: "\n\(ti)\n")
    }
    
    func testDayStartTimeIntervalExtension() {
        let now = TimeInterval().now()
        log.debug(message: "\(now)")
        
        let dayStartTimeInterval = now.dayStartTimeInterval()
        log.debug(message: "\(dayStartTimeInterval)")
        
        XCTAssertEqual(now.getYYMMDD(), dayStartTimeInterval.getYYMMDD())
        
        
    }
    
    func testDayEndTimeIntervalExtension() {
        let now = TimeInterval().now()
        let dayStartTimeInterval = now.dayStartTimeInterval()
        let dayEndTimeInterval = now.dayEndTimeInterval()
        
        XCTAssertEqual(dayStartTimeInterval.getYYMMDD(), dayEndTimeInterval.getYYMMDD())
        
        let tomorrow = dayEndTimeInterval.plusSecond(secondAmount: 1)
        XCTAssertNotEqual(dayStartTimeInterval.getYYMMDD(), tomorrow.getYYMMDD())
    }
    
    func testDayInterval() {
        let now = TimeInterval().now()
        let start = now.dayStartTimeInterval()
        let end = now.dayEndTimeInterval()
        
        let interval:(TimeInterval, TimeInterval) = now.dayInterval()
        log.debug(message: "start : \(start)   end \(end)")
        XCTAssertEqual(interval.0, start)
        XCTAssertEqual(interval.1, end)
        
        let yesterday = now.minusDay(dayAmount: 1).dayStartTimeInterval()
        log.debug(message: "yesterday : \(yesterday)")
    }
    
    func testCalcTimeMethod() {
        let todayStart = TimeInterval().now().dayStartTimeInterval()
        let tomorrow = todayStart.plusDay(dayAmount: 1)
        
        log.debug(message: "\(todayStart.getYYMMDD())")
        log.debug(message: "\(tomorrow.getYYMMDD())")
        
        XCTAssertEqual(todayStart.plusHour(hourAmount: 24).getYYMMDD(), tomorrow.getYYMMDD())
    }

    func testYearInterval() {
        let now = TimeInterval().now()
        let pastYearToday = now.minusYear(yearAmount: 1)
        let afterYearToday = now.plusYear(yearAmount: 1)
        
        log.debug(message: "now : \(now.getYYMMDD())   pastYearToday \(pastYearToday.getYYMMDD())   afterYearToday  \(afterYearToday.getYYMMDD())")
    }
}
