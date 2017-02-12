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
    
    func save(dateTimeID:Double, content:String) -> (Bool, String) {
        var latestId = 0
        do {
            try realm.write {
                latestId = (realm.objects(Diary.self).max(ofProperty: "id") as Int?)!
                diary.id = latestId + 1
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
        log.info(message: "저장 완료 - id: \(latestId+1) dateTimeID: \(dateTimeID), content:\(content)")
        return (true, "저장 완료")
    }

    
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
        
        if (diarys.count < 1) {
            return diarysDict
        }
        
        for index in 0...diarys.count-1 {
            let diary:Diary = diarys[index]
            let key:String = diary.dateTimeID.getYYMMDD()
            if nil == diarysDict[key] {
                diarysDict.updateValue([diary], forKey: key)
            } else {
                var dayDiarys = diarysDict[key]
                dayDiarys?.append(diary)
                diarysDict.updateValue(dayDiarys!, forKey: key)
            }
        }
        
        // 날짜 안의 시간 sorting
        for key in diarysDict.keys {
            let diarys = diarysDict[key]
            let sortedDiarys = diarys?.sorted(by: { (diary1, diary2) -> Bool in
                return diary1.dateTimeID > diary2.dateTimeID
            })
            diarysDict.updateValue(sortedDiarys!, forKey: key)
        }
        return diarysDict
    }
    
//    
//    func getSortedDateList() -> [String] {
//        let sortedDate = Array(makeAllDiarysDictionary().keys).sorted(by: <)
//        var dateList = [String]()
//        
//        for index in 0...sortedDate.count-1 {
//            //첫번째는 넣고
//            if 0 == index {
//                let date:String = sortedDate[index].getDateString()
//                dateList.append(date)
//            }
//            else {
//                //두 번째부턴 전꺼랑 같은지 보고
//                let beforeDate:String = sortedDate[index-1].getDateString()
//                let nowDate:String = sortedDate[index].getDateString()
//                if false == checkOverlap(before: beforeDate, now: nowDate) {
//                    dateList.append(nowDate)
//                }
//            }
//        }
//        return dateList
//    }
//    
//    func checkOverlap(before:String, now:String) -> Bool {
//        if before != now {
//            return false
//        }
//        return true
//    }
//    
//    /*      section   [ 날짜 , 날짜 ...]
//                        l      l
//        contentsCount [ 갯수 , 갯수 ...]
//     
//                1 : 1
//     */
//    
//    func getContentsCountList() -> [Int] {
//        let allDiarys = makeAllDiarysDictionary()
//        let sortedDate = Array(makeAllDiarysDictionary().keys).sorted(by: <)
//        
//        var contentsCountAtSameDay = [Int]()
//        var count = 0
//        
//        for index in 0...sortedDate.count-1 {
//            if 0 == index {
//                count += 1
//            }
//            else {
//                //두 번째부턴 전꺼랑 같은지 보고
//                let beforeDate:String = sortedDate[index-1].getDateString()
//                let nowDate:String = sortedDate[index].getDateString()
//                
//                // 전꺼랑 다르면 여태 count 한 것 배열에 넣고 처음부터 다시 세기
//                if false == checkOverlap(before: beforeDate, now: nowDate) {
//                    contentsCountAtSameDay.append(count)
//                    count = 1
//                }
//                // 같으면 count
//                else {
//                    count += 1
//                }
//            }
//        }
//        
//        return [0]
//    }
//    
//    func countSameDayContents() -> [Int] {
//        var contetsCountInSameDay = [Int]()
//        
//        return contetsCountInSameDay
//    }
//    
//    
    
    
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
