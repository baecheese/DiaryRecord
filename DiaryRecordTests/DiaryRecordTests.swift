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
    }
    
    func testTimeIntervalNow() {
        let ti = TimeInterval().now()
        log.debug(message: "\n\(ti)\n")
    }

}
