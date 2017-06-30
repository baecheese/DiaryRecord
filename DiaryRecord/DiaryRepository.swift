//
//  DiaryRepository.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 1..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import Foundation
import RealmSwift

enum ContentsSaveError: Error {
    case contentsSizeIsOver
    case contentsIsEmpty
}

class DiaryRepository: NSObject {
    
    private let log = Logger(logPlace: DiaryRepository.self)
    private var realm = try! Realm()
    private let fileManager = FileManager.default
    private let imageManager = ImageFileManager.sharedInstance
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: DiaryRepository = DiaryRepository()
    
    /* Results<Diary> **/
    func getAllList() -> Results<Diary> {
        let diarys:Results<Diary> = realm.objects(Diary.self)
        return diarys
    }
    
    func getSelectedDiaryID(section:Int, row:Int) -> Int {
        let diarys:[String : Array<Diary>] = getAllByTheDate()
        let sortedDate = Array(diarys.keys).sorted(by: >)
        let targetDate = sortedDate[section]
        return ((diarys[targetDate]?[row])?.id)!
    }
 
    func getDiaryInfo(diaryID:Int) -> (Int?, Int?) {
        let diarysData:[String : Array<Diary>] = getAllByTheDate()
        let sortedDate = Array(diarysData.keys).sorted(by: >)
        
        var infoSection:Int? = nil
        var infoRow:Int? = nil
        
        for section in sortedDate {
            let diarys = diarysData[section]
            for diary in diarys! {
                if diary.id == diaryID {
                    infoSection = sortedDate.index(of: section)
                    infoRow = diarys?.index(of: diary)
                    break;
                }
            }
        }
        return (infoSection, infoRow)
    }
    
    func getDiarysOfOneDay(section:Int) -> [Diary] {
        let diarys:[String : Array<Diary>] = getAllByTheDate()
        let targetDate = getSortedAllDate()[section]
        return diarys[targetDate]!
    }
    
    func getSortedAllDate() -> Array<String> {
        let diarys:[String : Array<Diary>] = getAllByTheDate()
        return Array(diarys.keys).sorted(by: >)
    }
    
    /** 순서 */
    func isFrist(diaryInfo:(Int, Int)) -> Bool {
        if fristDiaryInfo() == diaryInfo {
            return true
        }
        return false
    }
    
    /** 순서 */
    func isLast(diaryInfo:(Int, Int)) -> Bool {
        if diaryInfo == (0, 0) {
            return true
        }
        return false
    }
    
    /** 갯수 */
    func haveLastOne() -> Bool {
        if getAllList().count == 1 {
            return true
        }
        return false
    }
    
    /** 가장 첫 번째로 쓴, 메인에서는 맨 아래에 있는 section, row */
    func fristDiaryInfo() -> (Int, Int) {
        let section = getSortedAllDate().count - 1
        let row = getDiarysOfOneDay(section: section).count - 1
        return (section, row)
    }
    
    func getLastDiaryOfSomeDay(dateInfo:Int) -> Int {
        return getDiarysOfOneDay(section: dateInfo).count - 1
    }
    
    func save(timeStamp:Double, content:String, imageData:Data?) -> (Bool, String) {
        let diary = Diary()
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
                if (content == "" || content == " ") {
                    throw ContentsSaveError.contentsIsEmpty
                }
                else if (content.characters.count > 1000) {
                    throw ContentsSaveError.contentsSizeIsOver
                }
                if (nil != imageData) {
                    diary.imageName = imageManager.saveImage(data: imageData!, id: diary.id)
                }
                realm.add(diary)
            }
        }
        catch ContentsSaveError.contentsIsEmpty {
            log.warn(message: "contentsIsEmpty")
            return (false, "The pages are blank.")
        }
        catch ContentsSaveError.contentsSizeIsOver {
            log.warn(message: "contentsIsOver")
            return (false, "글자수가 1000자를 넘었습니다.")
        }
        catch {
            log.error(message: "realm error on")
            return (false, "오류가 발생하였습니다. 메모를 복사한 후, 다시 시도해주세요.")
        }
        log.info(message: "저장 완료 - id: \(latestId) timeStamp: \(timeStamp), content:\(content), imageName: \(diary.imageName)")
        return (true, "저장 완료")
    }
    
    /** before / after : 수정 전 / 수정 후 이미지 존재 여부 */
    func edit(id: Int, content:String, before:Bool, after:Bool, newImageData:Data?) -> (Bool, String) {
        let diary = findOne(id: id)
        do {
            try realm.write {
                diary?.content = content
                // 이미지 박스에 이미지 있을 때
                if (true == after) {
                    // 새로운 이미지면
                    if newImageData != nil {
                        if (true == before) {
                            // 이전에도 이미지가 있었다면 지우고 저장
                            imageManager.deleteImageFile(imageName: (diary?.imageName)!)
                        }
                        diary?.imageName = imageManager.saveImage(data: newImageData!, id: id)
                    }
                    if newImageData == nil {
                        // 새로운 이미지가 아닌 원래 이미지면 아무것도 안함 
                    }
                }
                // 이미지 박스에 이미지 없을 때 (화면 상 이미지 삭제 했을 때)
                if (false == after) {
                    // 이전에 이미지 있었으면 파일 지우고 이름 nil로 수정
                    if (true == before) {
                        imageManager.deleteImageFile(imageName: (diary?.imageName)!)
                        diary?.imageName = nil
                    }
                    if (false == before) {
                        // 이전에도 없었으면 아무것도 안함
                    }
                    
                }
            }
        } catch ContentsSaveError.contentsIsEmpty {
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
        log.info(message: "수정 완료 - id: \(id) timeStamp: \(diary?.timeStamp), content:\(diary?.content), imageName: \(diary?.imageName)")
        return (true, "수정 완료")
    }
    
    
    /**
     (형식 ex)
     [
      2017.02.12 :
       [{ts:1486711142.1015279, text:"Frist message"}
        , {ts:1486711142.1015290, text:"Frist message2"}
       ],
      2017.02.11 :
       [ {ts:1486711142.1015279, text:"Frist message"}
       ]
     ]
     */
    func getAllByTheDate() -> [String : Array<Diary>] {
        var diaryDict = [String : Array<Diary>]()
        let diarys:Results<Diary> = realm.objects(Diary.self)
        
        // 비어있을 때
        if (diarys.count < 1) {
            return diaryDict
        }
        
        // diariesDict = { 날짜 (key) : [diary1, diary2] }
        // [diary1, diary2] -> dayDiaries (같은 날 다른 시간에 쓰여진 일기)
        for index in 0...diarys.count-1 {
            let diary:Diary = diarys[index]
            let key:String = diary.timeStamp.getDotDate()
            if nil == diaryDict[key] {
                diaryDict.updateValue([diary], forKey: key)
            } else {
                var dayDiaries = diaryDict[key]
                dayDiaries?.append(diary)
                diaryDict.updateValue(dayDiaries!, forKey: key)
            }
        }
        
        // 날짜 안의 시간 sorting (최신 시간 순)
        for key in diaryDict.keys {
            let diaries = diaryDict[key]
            let sortedDiaries = diaries?.sorted(by: { (diary1, diary2) -> Bool in
                return diary1.timeStamp > diary2.timeStamp
            })
            diaryDict.updateValue(sortedDiaries!, forKey: key)
        }
        return diaryDict
    }
    
    // 메인 테이블에서 선택한 diary
    func findOne(id:Int) -> Diary? {
        let selectedDiary = realm.objects(Diary.self).filter("id = \(id)")
        if (selectedDiary.isEmpty) {
            return nil
        }
        return selectedDiary[0]
    }
    
    func getIdAll() -> [Int]? {
        let ids = realm.objects(Diary.self).value(forKey: "id") as! Array<Int>
        if (ids.count == 0) {
            return nil
        }
        var idList = [Int]()
        for id in ids {
            idList.append(id)
        }
        return idList
    }
    
    //TODO cheesing 구현, [String : Array<Diary>] 로 변형하는 기능은 함수로 분리하여서 findAll과 공통으로 사용하도록 구현
//    func findByPeriod(start:TimeInterval, end:TimeInterval) -> [String : Array<Diary>] {
//        
//    }
    
    
    // 특정 데이터 인덱스 접근으로 삭제
    func delete(id:Int) {
        let diary = findOne(id: id)!
        try! realm.write {
            log.debug(message: "\(diary) 삭제")
            realm.delete(diary)
        }
    }

}
