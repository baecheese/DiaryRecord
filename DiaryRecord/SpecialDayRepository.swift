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
    private let wedgetManager = WedgetManager.sharedInstance
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: SpecialDayRepository = SpecialDayRepository()
    
    /** test 용 */
    func getAllToResults() -> Results<SpecialDay> {
        let SpecialDays:Results<SpecialDay> = realm.objects(SpecialDay.self)
        return SpecialDays
    }
    
    func getAll() -> [SpecialDay] {
        return Array(getAllToResults())
    }
    
    func getAllCount() -> Int {
        return getAll().count
    }
    
    func isRight(id:Int) -> Bool {
        let specialDays = getAll()
        /* 이미 스페셜 데이인 것을 한 번 더 누른 건 스페셜 데이 취소 */
        for before in specialDays {
            if (before.diaryID == id) {
                return true
            }
        }
        return false
    }
    
    /** 무료/유료 회원에 따라 저장 */
    func save(diaryID:Int) -> (Bool, String) {
        if false == isChargedMember() {
            return saveForNormal(diaryID: diaryID)
        }
        else {
            return saveForVIP(diaryID: diaryID)
        }
    }
    
    // 위젯 설정 - 1개만 저장 가능. 특별한 날 있으면 기존 특별한 날과 교체  / 위젯 설정 풀리면 - 여러 개 가능
    /* 일반 회원용, 1개의 특별한 날만 저장 가능 (저장 시, 이전 특별한 날 지워짐) \n **/
    func saveForNormal(diaryID:Int) -> (Bool, String) {
        let specialDay = SpecialDay()
        if 1 <= getAllCount() {
            deleteAll()
        }
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
    
    /* 유료 회원용 - 2개까지 저장 가능 **/
    func saveForVIP(diaryID:Int) -> (Bool, String) {
        if 2 > getAllCount() {
            let specialDay = SpecialDay()
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
        return (false, "두개 이상은 저장 불가. 하나를 지우시오")
    }
    
    func findOne(id:Int) -> SpecialDay? {
        let selectedSpecialDay = realm.objects(SpecialDay.self).filter("diaryID = \(id)")
        if (selectedSpecialDay.isEmpty) {
            return nil
        }
        log.debug(message: "selectedSpecialDay - \(selectedSpecialDay)")
        return selectedSpecialDay[0]
    }
    
    // 특정 데이터 인덱스 접근으로 삭제
    func delete(id:Int) {
        let specialDay = findOne(id: id)!
        try! realm.write {
            log.debug(message: "\(specialDay) 삭제")
            realm.delete(specialDay)
        }
    }
    
    func deleteAll() {
        let specialDays = Array(getAll())
        /* 이미 스페셜 데이인 것을 한 번 더 누른 건 스페셜 데이 취소 */
        for specialDay in specialDays {
            delete(id: specialDay.diaryID)
        }
    }
    
    // 인앱 결제 이후 변화 -- cheesing (추후 업데이트)
    func isChargedMember() -> Bool {
        return false
//        return true
    }
    
    
    
    
}
