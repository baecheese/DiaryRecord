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
        log.debug(message: "징이가 심심하다")
        
        log.info(message: "뭔가 중요한 정보여서 항시 남겨야 한다")
        
        log.warn(message: "날 수도 있을 것 같기는 한데 그렇다고 해서 앱이 멈추면 안되는 거다. 근데 자주 나면 체크는 해야겠다")
        
        log.error(message: "심각한 에러가 발생했는데, 그 내용을 로그로 남긴다")
        
        log.debug(message: TimeInterval().now())
        
        let now = TimeInterval().now()
        log.debug(message: now, now.plusDay(dayAmount: 1), now.plusDay(dayAmount: 2))
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

}
