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
    
    func nowTimestamp() -> TimeInterval {
        return NSDate().timeIntervalSince1970
    }
    
    func  calculateDate(dateTimeID:TimeInterval) -> String {
        let timestamp = dateTimeID
        let date = Date(timeIntervalSince1970: timestamp)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.locale = NSLocale.current
        let dateString = dateFormatter.string(from: date as Date)
        
        return dateString
    }
    
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
