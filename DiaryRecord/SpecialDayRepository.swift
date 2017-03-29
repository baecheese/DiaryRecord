//
//  SpecialDayRepository.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 29..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import RealmSwift

class SpecialDayRepository: NSObject {
    
    private let log = Logger(logPlace: SpecialDayRepository.self)
    private var realm = try! Realm()
    private let fileManager = FileManager.default
    private let imageManager = ImageFileManager.sharedInstance
    private let diaryRepository = DiaryRepository.sharedInstance
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: SpecialDayRepository = SpecialDayRepository()
    
    /* for test **/
    func getAll() -> Results<SpecialDay> {
        let SpecialDays:Results<SpecialDay> = realm.objects(SpecialDay.self)
        return SpecialDays
    }
    
    // 위젯 설정 - 1개만 저장 가능. 특별한 날 있으면 기존 특별한 날과 교체  / 위젯 설정 풀리면 - 여러 개 가능
    /* 위젯 설정 시, 1개의 특별한 날만 저장 가능 \n **/
    func save(diaryID:Int) -> (Bool, String) {
        let specialDay = SpecialDay()
//        if  {
//            
//        }
        do {
            try realm.write {
                specialDay.diaryID = diaryID
                realm.add(specialDay)
            }
        }
            
        catch {
            log.error(message: "realm error on")
            return (false, "오류가 발생하였습니다. 메모를 복사한 후, 다시 시도해주세요.")
        }
        log.info(message: "specialDay 저장 완료 - diaryID : \(diaryID)")
        return (true, "저장 완료")
    }
//    
//    func findAll() -> Diary? {
//        
//        let specialDayIDs:Results<SpecialDay> = realm.objects(SpecialDay.self)
//        
//        if (specialDayIDs.count < 1) {
//            return nil
//        }
//        
//        var specialDiarys = [Diary]()
//        for specialDay in specialDayIDs {
//            specialDiarys.append(diaryRepository.findOne(id: specialDay.diaryID)!)
//        }
//        
//        // diariesDict = { 날짜 (key) : [diary1, diary2] }
//        // [diary1, diary2] -> dayDiaries (같은 날 다른 시간에 쓰여진 일기)
//        for index in 0...diarys.count-1 {
//            let diary:Diary = diarys[index]
//            let key:String = diary.timeStamp.getYYMMDD()
//            if nil == diaryDict[key] {
//                diaryDict.updateValue([diary], forKey: key)
//            } else {
//                var dayDiaries = diaryDict[key]
//                dayDiaries?.append(diary)
//                diaryDict.updateValue(dayDiaries!, forKey: key)
//            }
//        }
//        
//        // 날짜 안의 시간 sorting (최신 시간 순)
//        for key in diaryDict.keys {
//            let diaries = diaryDict[key]
//            let sortedDiaries = diaries?.sorted(by: { (diary1, diary2) -> Bool in
//                return diary1.timeStamp > diary2.timeStamp
//            })
//            diaryDict.updateValue(sortedDiaries!, forKey: key)
//        }
//        return diaryDict
//    }
//    
//    // 메인 테이블에서 선택한 diary
//    func findOne(id:Int) -> Diary? {
//        let selectedDiary = realm.objects(Diary.self).filter("id = \(id)")
//        if (selectedDiary.isEmpty) {
//            return nil
//        }
//        return selectedDiary[0]
//    }
//    
//    //TODO cheesing 구현, [String : Array<Diary>] 로 변형하는 기능은 함수로 분리하여서 findAll과 공통으로 사용하도록 구현
//    //    func findByPeriod(start:TimeInterval, end:TimeInterval) -> [String : Array<Diary>] {
//    //
//    //    }
//    
//    
//    // 특정 데이터 인덱스 접근으로 삭제
//    func delete(id:Int) {
//        let diary = findOne(id: id)!
//        try! realm.write {
//            log.debug(message: "\(diary) 삭제")
//            realm.delete(diary)
//        }
//    }
}
