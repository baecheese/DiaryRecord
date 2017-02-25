//
//  DiaryRepository.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 1..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import Foundation
import RealmSwift

class DiaryRepository: NSObject {
    
    let log = Logger(logPlace: DiaryRepository.self)
    
    override init() {
        super.init()
    }
        
    enum ContentsSaveError: Error {
        case contentsSizeIsOver
        case contentsIsEmpty
    }
    
    var realm = try! Realm()
    let diary = Diary()
    
    func save(timeStamp:Double, content:String) -> (Bool, String) {
        var latestId = 0
        do {
            try realm.write {
                if (false == realm.isEmpty) {
                    latestId = (realm.objects(Diary.self).max(ofProperty: "id") as Int?)!
                    latestId += 1
                    diary.id = latestId
                }
                else if (true == realm.isEmpty) {
                    diary.id = latestId
                }
                diary.timeStamp = timeStamp
                diary.content = content
                if (content == "") {
                    throw ContentsSaveError.contentsIsEmpty
                }
                else if (content.characters.count > 1000) {
                    throw ContentsSaveError.contentsSizeIsOver
                }
                realm.add(diary)
            }
        }
        catch ContentsSaveError.contentsIsEmpty {
            log.warn(message: "contentsIsEmpty")
            return (false, "내용이 비어있습니다.")
        }
        catch ContentsSaveError.contentsSizeIsOver {
            log.warn(message: "contentsIsOver")
            return (false, "글자수가 1000자를 넘었습니다.")
        }
        catch {
            log.error(message: "realm error on")
            return (false, "오류가 발생하였습니다. 메모를 복사한 후, 다시 시도해주세요.")
        }
        log.info(message: "저장 완료 - id: \(latestId) timeStamp: \(timeStamp), content:\(content)")
        return (true, "저장 완료")
    }

    // 테스트 시, 사용
    func getDiarysAll() -> Results<Diary> {
        let diarys:Results<Diary> = realm.objects(Diary.self)
        return diarys
    }
    
    /*
     (형식 ex)
     [2017.02.12 : [{ts:1486711142.1015279, text:"Frist message"}, {ts:1486711142.1015290, text:"Frist message2"}], 2017.02.11 : [{ts:1486711142.1015279, text:"Frist message"}]]
     */
    // makeAllDiarysDictionary -> findDiarys
    
    func findDiarys() -> [String : Array<Diary>] {
        var diarysDict = [String : Array<Diary>]()
        let diarys = getDiarysAll()
        
        // 비어있을 때
        if (diarys.count < 1) {
            return diarysDict
        }
        
        // diarysDict = { 날짜 (key) : [diary1, diary2] }
        // [diary1, diary2] -> dayDiarys (같은 날 다른 시간에 쓰여진 일기)
        for index in 0...diarys.count-1 {
            let diary:Diary = diarys[index]
            let key:String = diary.timeStamp.getYYMMDD()
            if nil == diarysDict[key] {
                diarysDict.updateValue([diary], forKey: key)
            } else {
                var dayDiarys = diarysDict[key]
                dayDiarys?.append(diary)
                diarysDict.updateValue(dayDiarys!, forKey: key)
            }
        }
        
        // 날짜 안의 시간 sorting (최신 시간 순)
        for key in diarysDict.keys {
            let diarys = diarysDict[key]
            let sortedDiarys = diarys?.sorted(by: { (diary1, diary2) -> Bool in
                return diary1.timeStamp > diary2.timeStamp
            })
            diarysDict.updateValue(sortedDiarys!, forKey: key)
        }
        return diarysDict
    }
    
    // 메인 테이블에서 선택한 diary
    func getDiary(id:Int) -> Diary {
        var seletedDiary = realm.objects(Diary.self).filter("id = \(id)")
        let diary = seletedDiary[0]
        return diary
    }
    
    // 특정 데이터 인덱스 접근으로 삭제
    func deleteDiary(id:Int) {
        let diary =  getDiary(id: id)
        do {
            try! realm.write {
                realm.delete(diary)
            }
        } catch {
            log.error(message: "realm error on")
        }
    }
    
    
    
}
