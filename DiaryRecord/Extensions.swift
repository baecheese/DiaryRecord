//
//  Extensions.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 12..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import Foundation


extension TimeInterval {
    
    // 현재 시간
    func now() -> TimeInterval {
        return NSDate().timeIntervalSince1970
    }
    
    // 타임스탬프 -> 날짜 계산 (long type)
    func getDateString() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date as Date)
    }
    
    // 타임스탬프 -> 시간 계산
    func getTimeString() -> String {
        let time = Date(timeIntervalSince1970: self)
        let timeFormatter = DateFormatter()
        timeFormatter.timeStyle = DateFormatter.Style.short
        timeFormatter.locale = NSLocale.current
        let timeString = timeFormatter.string(from: time as Date)
        
        return timeString
    }
    
    func getYYMMDD() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date as Date)
    }
    
    //시간 정보
    func getHHMM() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date as Date)
    }
    
}
