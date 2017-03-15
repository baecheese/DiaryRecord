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
    
    let log = Logger(logPlace: DiaryRepository.self)
    var realm = try! Realm()
    let fileManager = FileManager.default
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: DiaryRepository = DiaryRepository()
    
    //for test
    func getAll() -> Results<Diary> {
        let diarys:Results<Diary> = realm.objects(Diary.self)
        return diarys
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
                if (content == "") {
                    throw ContentsSaveError.contentsIsEmpty
                }
                else if (content.characters.count > 1000) {
                    throw ContentsSaveError.contentsSizeIsOver
                }
                if (nil != imageData) {
                    diary.imageName = saveImage(data: imageData!, id: diary.id)
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
        log.info(message: "저장 완료 - id: \(latestId) timeStamp: \(timeStamp), content:\(content), imageName: \(diary.imageName)")
        return (true, "저장 완료")
    }
    
    func edit(id: Int, content:String, imageData:Data?) -> (Bool, String) {
        let diary = findOne(id: id)
        do {
            try realm.write {
                diary?.content = content
                if (nil == imageData) {
                    diary?.imageName = nil
                }
                else if (nil != imageData) {
                    diary?.imageName = saveImage(data: imageData!, id: id)
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
        log.info(message: "저장 완료 - id: \(id) timeStamp: \(diary?.timeStamp), content:\(diary?.content), imageName: \(diary?.imageName)")
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
    func findAll() -> [String : Array<Diary>] {
        var diarysDict = [String : Array<Diary>]()
        let diarys:Results<Diary> = realm.objects(Diary.self)
        
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
    func findOne(id:Int) -> Diary? {
        let seletedDiary = realm.objects(Diary.self).filter("id = \(id)")
        if (seletedDiary.isEmpty) {
            return nil
        }
        return seletedDiary[0]
    }
    
    //TODO cheesing 구현, [String : Array<Diary>] 로 변형하는 기능은 함수로 분리하여서 findAll과 공통으로 사용하도록 구현
//    func findByPeriod(start:TimeInterval, end:TimeInterval) -> [String : Array<Diary>] {
//        
//    }
    
    
    
    // 특정 데이터 인덱스 접근으로 삭제
    func delete(id:Int) {
        try! realm.write {
            let diary = findOne(id: id)!
            realm.delete(diary)
        }
    }
    
    
    /* Image 관련 */
    func getImageData(info:[String : Any]) -> Data {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.7)
        return data!
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
    /** isExistImage와 getImageFilePath에서 쓰기 위한 용도*/
    private func checkExistsImageFile(imageName:String) -> (Bool, String?) {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(imageName)?.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath!) {
            return (true, path)
        } else {
            return (false, nil)
        }
    }
    
    private func isExistImage(imageName:String) -> Bool {
        return checkExistsImageFile(imageName: imageName).0
    }
    
    private func getImageFilePath(imageName:String) -> String? {
        return checkExistsImageFile(imageName: imageName).1
    }
    
    private func saveImage(data:Data, id:Int) -> String {
        let imageName = "\(id)" + ".jpeg"
        if false == isExistImage(imageName: imageName) {
            let filename = getDocumentsDirectory().appendingPathComponent(imageName)
                try? data.write(to: filename)
        }
        return imageName
    }
    
    func deleteImageFile(imageName:String) {
        if true == isExistImage(imageName: imageName) {
            do {
                // path 를 checkExistsImage와 같은 형태로 확인
                try fileManager.removeItem(atPath: getImageFilePath(imageName: imageName)!)
                log.info(message: "이미지 삭제 성공")
            }
            catch {
                log.error(message: "이미지 삭제에 실패하였습니다")
            }
        }
        else {
            log.debug(message: "이미 삭제되거나 없는 이미지 입니다.")
        }
    }
    
    func showImage(imageName:String) -> UIImage? {
        if isExistImage(imageName: imageName) {
            let imageURL = URL(fileURLWithPath: getDirectoryPath()).appendingPathComponent(imageName)
            return UIImage(contentsOfFile: imageURL.path)
        }
        return nil
    }
    
    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths.first
        return documentsDirectory!
    }
}
