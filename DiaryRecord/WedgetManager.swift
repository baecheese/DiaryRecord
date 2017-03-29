//
//  WedgetManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 29..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/* 0. 랜덤 (default) / 1. 스페셜데이: 1개만 / 2. 과거의 오늘 **/
struct WedgetMode {
    let list = ["랜덤", "스페셜데이", "과거의 오늘"]
}

class WedgetManager: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: WedgetManager = WedgetManager()
    let defaults = UserDefaults.standard
    
    let log = Logger(logPlace: WedgetManager.self)
    
    /* 0. 랜덤 (default) / 1. 스페셜데이: 1개만 / 2. 과거의 오늘 **/
    func setMode(number:Int) {
        defaults.set(number, forKey: "wedgetMode")
        log.info(message: "wedgetMode 저장 완료 : \(getMode())")
    }
    
    func setAndGetMode(number:Int) -> Int {
        defaults.set(number, forKey: "wedgetMode")
        log.info(message: "테마 저장 완료 : \(getMode())")
        return getMode()
    }
    
    func getMode() -> Int {
        if defaults.value(forKey: "wedgetMode") == nil {
            return setAndGetMode(number: 0)
        }
        return defaults.value(forKey: "theme") as! Int
    }
}
