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
    
    func getYYMMDD() -> String {
        return formatString(format: "yyyy-MM-dd")
    }
    
    //시간 정보
    func getHHMM() -> String {
        return formatString(format: "HH:mm")
    }
    
    func formatString(format:String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date as Date)
    }
    
    /**
     day start, end TimeInterval
        - Returns: (day start, day end)
    */
    func dayInterval() -> (TimeInterval, TimeInterval) {
        return (dayStartTimeInterval(), dayEndTimeInterval())
    }
    
    func dayStartTimeInterval() -> TimeInterval {
        let format = "yyyy:MM:dd"
        let dateString = formatString(format: format)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale.current
        let dayStartDate = dateFormatter.date(from: dateString)
        return (dayStartDate?.timeIntervalSince1970)!
    }
    
    func dayEndTimeInterval() -> TimeInterval {
        let tomorrow = self.plusDay(dayAmount: 1)
        return tomorrow.dayStartTimeInterval() - 1
    }
    
    func plusDay(dayAmount:Int) -> TimeInterval {
        let plusSecondsAmount = (TimeInterval)((60 * 60 * 24) * dayAmount)
        return self + plusSecondsAmount
    }
    
    func minusDay(dayAmount:Int) -> TimeInterval {
        let minusSecondsAmount = (TimeInterval)((60 * 60 * 24) * dayAmount)
        return self - minusSecondsAmount
    }
    
    func plusHour(hourAmount:Int) -> TimeInterval {
        let plusSecondsAmount = (TimeInterval)((60 * 60) * hourAmount)
        return self + plusSecondsAmount
    }
    
    func minusHour(hourAmount:Int) -> TimeInterval {
        let minusSecondsAmount = (TimeInterval)((60 * 60) * hourAmount)
        return self - minusSecondsAmount
    }
    
    func plusMinute(minuteAmount:Int) -> TimeInterval {
        let plusSecondsAmount = (TimeInterval)(60 * minuteAmount)
        return self + plusSecondsAmount
    }
    
    func minusMinute(minuteAmount:Int) -> TimeInterval {
        let minusSecondsAmount = (TimeInterval)(60 * minuteAmount)
        return self - minusSecondsAmount
    }
    
    func plusSecond(secondAmount:Int) -> TimeInterval {
        let plusSecondsAmount = (TimeInterval)(secondAmount)
        return self + plusSecondsAmount
    }
    
    func minusSecond(secondAmount:Int) -> TimeInterval {
        let minusSecondsAmount = (TimeInterval)(secondAmount)
        return self - minusSecondsAmount
    }
}
