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
    
    // NSDate().timeIntervalSince1970 -> 현재 타임 스탬프
    //-- 타임스탬프 넣으면 계산 할 수 있게
    
    
    func  CalculatorDate(dateTimeID:Double) -> String {
        let timestamp = Date(timeIntervalSince1970: dateTimeID)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.locale = NSLocale.current
        let dateString = dateFormatter.string(from: timestamp as Date)
        
        return dateString
    }
    
    func timeCalculation() {
        
    }
    
    func makeDate() -> (Int, String) {
        let now = NSDate()
        
        let dateNumberFormatter = DateFormatter()
        dateNumberFormatter.dateFormat = "yyyyMMdd"
        dateNumberFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        let dateNumber = Int(dateNumberFormatter.string(from: now as Date))
        
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        let dateString = dateStringFormatter.string(from: now as Date)
        
        return (dateNumber!, dateString)
    }
    
    func makeTime() -> (Int, String) {
        let now = NSDate()
        
        let timeNumberFormatter = DateFormatter()
        timeNumberFormatter.dateFormat = "HHmmss"
        timeNumberFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        let timeNumber = Int(timeNumberFormatter.string(from: now as Date))
        
        let timeStrigFormatter = DateFormatter()
        timeStrigFormatter.dateFormat = "HH:mm:ss"
        timeStrigFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        let timeString = timeStrigFormatter.string(from: now as Date)
        
        return (timeNumber!, timeString)
    }
    
    
}
