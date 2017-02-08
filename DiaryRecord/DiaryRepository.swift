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
    
    func saveDiaryToRealm(dateId:Int, timeId:Int, date:String, time:String, content:String) -> (Bool, String) {
        
        do {
            try realm.write {
                diary.dateId = dateId
                diary.timeId = timeId
                diary.data = date
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
        log.info(message: "저장 완료 - dateId:\(dateId), timeId:\(timeId), data:\(date), time:\(time), content:\(content)")
        return (true, "저장 완료")
    }

    
    func getDiarysAll() -> Results<Diary> {
        let diarys:Results<Diary> = realm.objects(Diary.self)
        log.info(message: "\(diarys)")
        return diarys
    }
    
    /*
     1. restult <T>  전체 루프 -> dateID 추출
     2. date 날짜순 정렬
     3. 필터링으로 날짜순 + 시간 순
     */
    
    // section list (날짜 순 날짜 리스트)
    func getDateFromEarlierDate() -> Array<Int> {
        let diaryAllArray = Array(getDiarysAll())
        var dateList = [Int]()
        for index in 0...diaryAllArray.count-1 {
            //하나씩 꺼내서
            let oneDiary = dateList[index]
            
            ///////// ------- one diary 가 딕셔너리인지, 확인해보기. 그래야 아래의 키로 벨류 찾을 수 있는 것 가능
            
            // 날짜 부분만
            //dateList.append(oneDiary.value(forKey: "dateId") as! Int)
        }
        let uniqueDateList = removeOverlapObjectOfArray(source: dateList)
        return uniqueDateList.sorted()
    }
    
    func removeOverlapObjectOfArray<T: Equatable>(source: [T]) -> [T] {
        var unique = [T]()
        for item in source {
            if !unique.contains(item) {
                unique.append(item)
            }
        }
        return unique
    }
    
    // row
//    func timeSequenceDiaryOfSameDay() ->  {
//        // section의 날짜이면서
//        // 같은 날짜의 모든 데이터 -> 시간만 뺌
//        // sort 시간 순 리스트
//        // sort해놓은 시간 순서로 루프
//    }
    
    
    
    
    // -- 특정 데이터 인덱스 접근으로 삭제 -- cheesing
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
