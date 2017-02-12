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
    
    func saveDiaryToRealm(dateTimeID:Double, content:String) -> (Bool, String) {
        
        do {
            try realm.write {
                diary.dateTimeID = dateTimeID
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
        log.info(message: "저장 완료 - dateTimeID: \(dateTimeID), content:\(content)")
        return (true, "저장 완료")
    }

    
    func getDiarysAll() -> Results<Diary> {
        let diarys:Results<Diary> = realm.objects(Diary.self)
        return diarys
    }
    
    
    /*
     1. 데이터 꺼내서
     2. key value로 dateTimeID : content 정렬
     
     (형식 ex)
     [1486711142.1015279: "Frist message", 1486711159.7582421: "Second message", 1486872493.6400831: "일요일 메모 입니다.", 1486872516.3069069: "라이온킹 노래를 듣고 있다.", 1486872506.9079449: "날짜가 달라져야겠죠"]
     
     */
    
    func makeAllDiarysDictionary() -> [Double : String] {
        
        var diaryDictionary = [Double : String]()
        
        let diarys = getDiarysAll()
        for index in 0...diarys.count-1 {
            var diary = diarys[index]
            let key = diary.value(forKey: "dateTimeID")
            let value = diary.value(forKey: "content")
            diaryDictionary.updateValue(value as! String, forKey: key as! Double)
        }
        
        return diaryDictionary
    }
    
    func getDateList() -> [String] {
        let sortedDate = Array(makeAllDiarysDictionary().keys).sorted(by: <)
        var dateList = [String]()
        
        for index in 0...sortedDate.count-1 {
            //첫번째는 넣고
            if 0 == index {
                let date:String = CalculatorCalendar()
                    .calculateDateString(dateTimeID: sortedDate[index])
                dateList.append(date)
            }
            else {
                //두 번째부턴 전꺼랑 같은지 보고
                let beforeDate:String = CalculatorCalendar()
                    .calculateDateString(dateTimeID: sortedDate[index-1])
                let nowDate:String = CalculatorCalendar()
                    .calculateDateString(dateTimeID: sortedDate[index])
                
                if false == checkOverlap(before: beforeDate, now: nowDate) {
                    dateList.append(nowDate)
                }
            }
        }
        return dateList
    }
    
    func checkOverlap(before:String, now:String) -> Bool {
        if before != now {
            return false
        }
        return true
    }
    
    func getContentsCountList() -> [Int] {
        return [0]
    }
    
    func countSameDayContents() -> [Int] {
        var contetsCountInSameDay = [Int]()
        
        return contetsCountInSameDay
    }
    
    
    
    
    ////------------------------ 공사중 --------------------------------------- //
    
    
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
