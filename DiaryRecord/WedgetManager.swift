//
//  WedgetManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 29..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/* 0. 랜덤 (default) / 1. 과거의 오늘 / 2.스페셜데이: 1개만 **/
struct WedgetMode {
    let list = ["랜덤", "과거의 오늘", "특별한 날 (사용자 지정)"]
}

class WedgetManager: NSObject {
    
    let log = Logger(logPlace: WedgetManager.self)
    static let sharedInstance: WedgetManager = WedgetManager()
    let localDefaults = UserDefaults.standard
    let groupDefaults = UserDefaults(suiteName: "group.com.baecheese.DiaryRecord")
    
    private override init() {
        super.init()
    }
    
    /* 0. 랜덤 (default) / 1. 과거의 오늘 / 2.스페셜데이: 1개만 **/
    func setMode(number:Int) {
        localDefaults.set(number, forKey: "wedgetMode")
        log.info(message: "wedgetMode 저장 완료 : \(getMode())")
        setContentsInWedget(mode: number)
    }
    
    func setAndGetMode(number:Int) -> Int {
        localDefaults.set(number, forKey: "wedgetMode")
        log.info(message: "테마 저장 완료 : \(getMode())")
        setContentsInWedget(mode: number)
        return getMode()
    }
    
    func getMode() -> Int {
        if localDefaults.value(forKey: "wedgetMode") == nil {
            return setAndGetMode(number: 0)
        }
        return localDefaults.value(forKey: "wedgetMode") as! Int
    }
    
    func setContentsInWedget(mode:Int) {
        if (mode == 1) {
            localDefaults.set(todayOfPast(), forKey: "WedgetContents")
            return;
        }
        if (mode == 2) {
            localDefaults.set(specialDay(), forKey: "WedgetContents")
            return;
        }
        // default 위젯 (랜덤)
        localDefaults.set(getRandom(), forKey: "WedgetContents")
    }
    
    func getRandom() -> String? {
        let allDairyList = DiaryRepository.sharedInstance.getAllList()
        let lastIndex = allDairyList.count - 1
        let randomNo = arc4random_uniform(UInt32(lastIndex))// 0 ~ lastIndex
        let selectDairy = DiaryRepository.sharedInstance.findOne(id: Int(randomNo))
        
        return selectDairy?.content
    }
    
    func todayOfPast() -> String {
        return "과거의 오늘 내용"
    }
    
    func specialDay() -> String {
        return "특별한날 (사용자 지정) 내용"
    }
    
    
}
