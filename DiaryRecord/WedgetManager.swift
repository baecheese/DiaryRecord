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

struct GroupKeys {
    let suiteName = "group.com.baecheese.DiaryRecord"
    let contents = "WedgetContents"
    let image = "ImageFile"
}

class WedgetManager: NSObject {
    
    let log = Logger(logPlace: WedgetManager.self)
    let wedgetGroupKey = GroupKeys()
    static let sharedInstance: WedgetManager = WedgetManager()
    
    let diaryRepository = DiaryRepository.sharedInstance
    let imageManager = ImageFileManager.sharedInstance
    
    let localDefaults = UserDefaults.standard
    /* WedgetContents, ImageFile **/
    let groupDefaults = UserDefaults(suiteName: GroupKeys().suiteName)

    
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
    
    
    private var selectDiary = Diary()
    
    func setContentsInWedget(mode:Int) {
        if (mode == 0) {
            // default 위젯 (랜덤)
            groupDefaults?.set(getRandom(), forKey: wedgetGroupKey.contents)
        }
        if (mode == 1) {
            groupDefaults?.set(todayOfPast(), forKey: wedgetGroupKey.contents)
        }
        if (mode == 2) {
            groupDefaults?.set(specialDay(), forKey: wedgetGroupKey.contents)
        }
        if nil != selectDiary.imageName {
            let image = imageManager.showImage(imageName: selectDiary.imageName!)
            let imageData = UIImagePNGRepresentation(image!)
            saveImage(data: imageData!)
        }
        if nil == selectDiary.imageName && true == haveBeforeImage() {
            deleteBeforeImage()
        }
        
        log.info(message: "getWedgetContents : \(getWedgetContents())")
    }
    
    private func getRandom() -> String? {
        let allDairyList = diaryRepository.getAllList()
        let lastIndex = allDairyList.count - 1
        let randomNo = arc4random_uniform(UInt32(lastIndex))// 0 ~ lastIndex
        selectDiary = diaryRepository.findOne(id: Int(randomNo))!
        log.info(message: "Random Dairy Content: \(selectDiary.content)")
        return selectDiary.content
    }
    
    private func todayOfPast() -> String? {
        let allDate = Array(diaryRepository.getAllByTheDate().keys)
        let today = TimeInterval().now().getYYMMDD()
        var todayOfPast:[Diary] = []
        for date in allDate {
            if date == today {
                todayOfPast = diaryRepository.getAllByTheDate()[date]!
            }
        }
        
        if 0 < todayOfPast.count {
            let lastIndex = todayOfPast.count - 1
            let randomIndex = Int(arc4random_uniform(UInt32(lastIndex)))// 0 ~ lastIndex
            selectDiary = todayOfPast[randomIndex]
            return selectDiary.content
        }
        
        selectDiary = Diary()
        return " 과거의 오늘 \n \(TimeInterval().now().minusYear(yearAmount: 1).getYYMMDD()) \n 일기가 없습니다."
    }
    
    // -- cheesing
    private func specialDay() -> String {
        
        selectDiary = Diary()
        return "특별한 날 지정이 없습니다."
    }
    
    private func saveImage(data:Data) {
        groupDefaults?.set(data, forKey: wedgetGroupKey.image)
        log.info(message: " get wedgetImage : \(groupDefaults?.value(forKey: wedgetGroupKey.image))")
    }
    
    
    private func haveBeforeImage() -> Bool {
        if nil == groupDefaults?.value(forKey: wedgetGroupKey.image) {
            return false
        }
        return true
    }
    
    private func deleteBeforeImage() {
        log.info(message: " deleteBeforeImage before get wedgetImage : \(groupDefaults?.value(forKey: wedgetGroupKey.image))")
        groupDefaults?.removeObject(forKey: wedgetGroupKey.image)
        log.info(message: " deleteBeforeImage after get wedgetImage : \(groupDefaults?.value(forKey: wedgetGroupKey.image))")
    }
    
    /* 잘 들어갔는지 로그 확인 용 **/
    private func getWedgetContents() -> String {
        if let groupDefaults = UserDefaults(suiteName: wedgetGroupKey.suiteName),
            let data = groupDefaults.value(forKey: wedgetGroupKey.contents) as? String {
            return data
        }
        return "위젯 설정 내용 없음"
    }
    
    
}
