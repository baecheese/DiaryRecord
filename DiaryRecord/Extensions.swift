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
    
    //시간 정보
    func getHHMM() -> String {
        return formatString(format: "HH:mm")
    }
    
    func getDotDate() -> String {
        return formatString(format: "yyyy.MM.dd")
    }
    
    func getYYMMDD() -> String {
        return formatString(format: "yyyy-MM-dd")
    }
    
    func getDateLongStyle() -> String {
        return longformatString()
    }
    
    func getAllTimeInfo() -> String {
        // "Jun 27, 2015, 11:30 PM"
        return formatString(format: "yyyy.MM.dd a h:mm")
    }
    
    func formatString(format:String) -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        dateFormatter.locale = NSLocale.current
        return dateFormatter.string(from: date as Date)
    }
    
    func longformatString() -> String {
        let date = Date(timeIntervalSince1970: self)
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = DateFormatter.Style.long
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
    
    /* wiki에 note */
    func dayStartTimeInterval() -> TimeInterval {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy:MM:dd"
        dateFormatter.locale = NSLocale.current
        let dateString = dateFormatter.string(from: Date(timeIntervalSince1970: self))
        let dayStartDate = dateFormatter.date(from: dateString)
        return (dayStartDate?.timeIntervalSince1970)!
    }
    
    func dayEndTimeInterval() -> TimeInterval {
        let tomorrow = self.plusDay(dayAmount: 1)
        return tomorrow.dayStartTimeInterval().minusSecond(secondAmount: 1)
    }
    
    
    func plusYear(yearAmount:Int) -> TimeInterval {
        let plusSecondsAmount = (TimeInterval)((60 * 60 * 24) * 365 * yearAmount)
        return self + plusSecondsAmount
    }
    
    func minusYear(yearAmount:Int) -> TimeInterval {
        let minusSecondsAmount = (TimeInterval)((365 * 60 * 60 * 24) * yearAmount)
        return self - minusSecondsAmount
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
    
    private func getBeforeDayEndData() -> TimeInterval? {
        let defaults = UserDefaults.standard
        return defaults.value(forKey: "beforeDay") as? TimeInterval
    }
    
    private func saveNewBeforeDayEndTime() {
        let todayEnd = TimeInterval().now().dayEndTimeInterval()
        UserDefaults.standard.set(todayEnd, forKey: "beforeDay")
    }
    
    func passADay() -> Bool {
        if getBeforeDayEndData() == nil {
            saveNewBeforeDayEndTime()
        }
        let beforeEnd = getBeforeDayEndData()
        let now = TimeInterval().now()
        
        if beforeEnd! < now  {
            saveNewBeforeDayEndTime()
            return true
        }
        return false
    }
    
}
