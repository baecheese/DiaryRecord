//
//  CalculatorCalendar.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 10..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import Foundation

class CalculatorCalendar : NSObject {
    
    override init() {
        super.init()
    }
    
    // 현재 시간
    func nowTimestamp() -> TimeInterval {
        return NSDate().timeIntervalSince1970
    }
    
    // 타임스탬프 -> 날짜 계산 (long type)
    func  calculateDateString(dateTimeID:TimeInterval) -> String {
        let timestamp = dateTimeID
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date as Date)
    }
    
    // 타임스탬프 -> 시간 계산
    func calculateTime(dateTimeID:TimeInterval) -> String {
        let timestamp = dateTimeID
        let time = Date(timeIntervalSince1970: timestamp)
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        timeFormatter.locale = NSLocale.current
        let timeString = timeFormatter.string(from: time as Date)
        
        return timeString
    }
    
    
}
