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
    
    
    
}
