//
//  WedgetManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 29..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 0. 랜덤 (default) / 1. 과거의 오늘 / 2.스페셜데이: 1개만 */
struct WedgetMode {
    let list = ["랜덤", "과거의 오늘", "특별한 날 (사용자 지정)"]
}

struct LocalKey {
    let mode = "wedgetMode"
}

/** 위젯에 넘기는 용으로 쓰는 것 */
struct GroupKeys {
    let suiteName = "group.com.baecheese.DiaryRecord"
    let id = "ID"
    let contents = "WedgetContents"
    let image = "ImageFile"
}

/** 📁 LocalKeys : wedgetMode
 📱 GroupKeys : let suiteName = "group.com.baecheese.DiaryRecord" /
 let id = "ID"  /
 let contents = "WedgetContents"  /
 let image = "ImageFile" */
class WedgetManager: NSObject {
    
    let log = Logger(logPlace: WedgetManager.self)
    let wedgetLocalKey = LocalKey()
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
        localDefaults.set(number, forKey: wedgetLocalKey.mode)
        log.info(message: "wedgetMode 저장 완료 : \(getMode())")
        setContentsInWedget(mode: number)
    }
    
    func setAndGetMode(number:Int) -> Int {
        localDefaults.set(number, forKey: wedgetLocalKey.mode)
        log.info(message: "테마 저장 완료 : \(getMode())")
        setContentsInWedget(mode: number)
        return getMode()
    }
    
    /** 현재 위젯 모드 0. 랜덤 (default) / 1. 과거의 오늘 / 2.스페셜데이: 1개만 */
    func getMode() -> Int {
        if localDefaults.value(forKey: wedgetLocalKey.mode) == nil {
            return setAndGetMode(number: 0)
        }
        return localDefaults.value(forKey: wedgetLocalKey.mode) as! Int
    }
    
    func setContentsInWedget(mode:Int) {
        var diary:Diary? = nil
        
        if haveBeforeImage() {
            deleteBeforeImage()
        }
        
        if (mode == 0) {
            // default 위젯 (랜덤)
            diary = getRandom()
        }
        if (mode == 1) {
            // 과거의 오늘
            diary = todayOfPast()
            if nil == todayOfPast() {
                saveContents(contents: "과거의 오늘 일기가 없습니다.")
                return;
            }
        }
        if (mode == 2) {
            // 저장한 특별한 날 가져오기
            diary = specialDay()
            if nil == diary {
                saveContents(contents: "특별한 날 지정이 없습니다.")
                return;
            }
        }
        
        saveContents(contents: (diary?.content)!)
        saveImage(imageName: diary?.imageName)
//        saveID(id: ??)
        log.info(message: "getWedgetContents : \(getWedgetContents())")
    }
    
    private func saveContents(contents:String) {
        groupDefaults?.set(contents, forKey: wedgetGroupKey.contents)
    }
    
    private func getRandom() -> Diary? {
        let allDairyList = diaryRepository.getAllList()
        if 1 < allDairyList.count {
            let lastIndex = allDairyList.count - 1
            let randomNo = arc4random_uniform(UInt32(lastIndex))// 0 ~ lastIndex
            let selectDiary = diaryRepository.findOne(id: Int(randomNo))!
            log.info(message: "Random Dairy Content: \(selectDiary.content)")
            return selectDiary
        }
        return nil
    }
    
    private func todayOfPast() -> Diary? {
        var selectDiary = Diary()
        let allDate = Array(diaryRepository.getAllByTheDate().keys)
        let today = TimeInterval().now()
        let pastTodayDate = today.minusYear(yearAmount: 1).getYYMMDD()
        var todayOfPast:[Diary] = []
        for date in allDate {
            if date == pastTodayDate {
                todayOfPast = diaryRepository.getAllByTheDate()[date]!
            }
        }
        
        if 0 < todayOfPast.count {
            let lastIndex = todayOfPast.count - 1
            let randomIndex = Int(arc4random_uniform(UInt32(lastIndex)))// 0 ~ lastIndex
            selectDiary = todayOfPast[randomIndex]
            return selectDiary
        }
        log.info(message: " 과거의 오늘 \n \(TimeInterval().now().minusYear(yearAmount: 1).getYYMMDD()) \n 일기가 없습니다.")
        return nil
    }
    
    // -- cheesing
    private func specialDay() -> Diary? {
        let selectDiary = Diary()
//        if true {
//            // 지정된 특별한 날 잇을때
//            return selectDiary
//        }
//        
        
        return nil
    }
    
    private func saveImage(imageName:String?) {
        if nil != imageName {
            let image = imageManager.showImage(imageName: imageName!)
            let imageData = UIImagePNGRepresentation(image!)
            groupDefaults?.set(imageData, forKey: wedgetGroupKey.image)
//            log.info(message: " get wedgetImage : \(groupDefaults?.value(forKey: wedgetGroupKey.image))")
        }
    }
    
    private func deleteBeforeImage() {
        if true == haveBeforeImage() {
            groupDefaults?.removeObject(forKey: wedgetGroupKey.image)
        }
    }
    
    private func haveBeforeImage() -> Bool {
        if nil == groupDefaults?.value(forKey: wedgetGroupKey.image) {
            return false
        }
        return true
    }
    
    private func saveID(id:Int) {
        groupDefaults?.set(id, forKey: wedgetGroupKey.id)
        log.info(message: " get wedgetID : \(groupDefaults?.value(forKey: wedgetGroupKey.id))")
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
