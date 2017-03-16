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
                            deleteImageFile(imageName: (diary?.imageName)!)
                        }
                        diary?.imageName = saveImage(data: newImageData!, id: id)
                    }
                    if newImageData == nil {
                        // 새로운 이미지가 아닌 원래 이미지면 아무것도 안함 
                    }
                }
                // 이미지 박스에 이미지 없을 때 (화면 상 이미지 삭제 했을 때)
                if (false == after) {
                    // 이전에 이미지 있었으면 파일 지우고 이름 nil로 수정
                    if (true == before) {
                        deleteImageFile(imageName: (diary?.imageName)!)
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
    
    /** image picker 에서 이미지 선택 후 저장을 위한 데이터로 바꿀 때 사용*/
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
    
    /** isExistImage와 getImageFilePath에서 쓰기 위한 용도. 이미지가 들어있는 폴더 까지의 주소가 나온다. \n
      - ex : "/var/mobile/Containers/Data/Application/6360A4A6-C56B-40E5-AC36-D0A53ED734CE/Documents"*/
    private func getPath(imageName:String) -> String? {
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let url = NSURL(fileURLWithPath: path)
        let filePath = url.appendingPathComponent(imageName)?.path
        return filePath
    }
    
    private func isExistImage(imageName:String) -> Bool {
        let imagePath = getImageFilePath(imageName: imageName)!
        return fileManager.fileExists(atPath: imagePath)
    }
    
    private func getImageFilePath(imageName:String) -> String? {
        let path:String? = getPath(imageName: imageName)
        if (path == nil) {
            return nil
        }
        return "\(path)/\(imageName)"
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
