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
    
    
    func nowTimestamp() -> Double {
        return NSDate().timeIntervalSince1970
    }
    
    func  calculateDate(dateTimeID:Double) -> String {
        let timestamp = Date(timeIntervalSince1970: dateTimeID)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.locale = NSLocale.current
        let dateString = dateFormatter.string(from: timestamp as Date)
        
        return dateString
    }
    
    func calculateTime(dateTimeID:Double) -> String {
        
        let timestamp = Date(timeIntervalSince1970: dateTimeID)
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        timeFormatter.locale = NSLocale.current
        let timeString = timeFormatter.string(from: timestamp as Date)
        
        return timeString
    }
    
    
}
