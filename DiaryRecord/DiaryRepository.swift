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
    
    let log = Logger.init(logPlace: DiaryRepository.self)
    
    override init() {
        super.init()
    }
        
    enum ContentsSaveError: Error {
        case contentsSizeIsOver
        case contentsIsEmpty
    }
    
    var realm = try! Realm()
    let diary = Diary()
    
    func saveDiaryToRealm(data:String, time:String, content:String) -> (Bool, String) {
        
        do {
            try realm.write {
                diary.data = data
                diary.time = time
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
        log.debug(message: "저장 완료")
        return (true, "저장 완료")
        
    }

    
    func getDiarysAll() {
        let diarys:Results<Diary> = realm.objects(Diary.self)
        log.info(message: "\(diarys)")
    }
    
    // -- 특정 데이터 인덱스 접근으로 삭제
    func deleteDiary(index:Int) {
        let diarys:Results<Diary> = realm.objects(Diary.self)
        do {
            try! realm.write {
                realm.delete(diarys[index])
            }
        }
        catch {
            log.error(message: "realm error on")
        }
    }
    
//    func getDiarys() -> ??? {
//    // 일기 목록들 가져오기
//    // realm 쿼리 날리는 걸로 가져오게 하면 됨
//    // section이 날짜별로 분류되니, 날짜에 따른 컨텐츠 나오게 하면 될듯
//    }
    
}
