//
//  WedgetManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 29..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 0. 스페셜데이: 1개만 (default) / 1. 과거의 오늘 / 2. 랜덤 */
struct WedgetMode {
    let list = ["특별한 날 (사용자 지정)", "과거의 오늘 (1년 전 오늘)", "랜덤 (시크릿 모드시 불가)"]
}

struct WedgetFont {
    let size:CGFloat = 13.0
}

struct LocalKey {
    let mode = "wedgetMode"
}

/** 위젯에 넘기는 용으로 쓰는 것 */
struct GroupKeys {
    let suiteName = "group.com.baecheese.DiaryRecord"
    let contents = "WedgetContents"
    let image = "ImageFile"
    let nowWedgetID = "ID"
    let theme = "theme"
    let comeIntoTheWedget = "ComeIntoTheWedget"
//     let vipContetns = "VIPWedgetContents"
//     let vipImage = "VIPImageFile"

}

/** 📁 LocalKeys : wedgetMode
 📱 GroupKeys : let suiteName = "group.com.baecheese.DiaryRecord" /
 let id = "ID"  /
 let contents = "WedgetContents"  /
 let image = "ImageFile" */
class WedgetManager: NSObject {
    
    let log = Logger(logPlace: WedgetManager.self)
    let wedgetLocalKey = LocalKey()
    let wedgetGroupKey = GroupKeys()
    
    let diaryRepository = DiaryRepository.sharedInstance
    let specialDayRepository = SpecialDayRepository.sharedInstance
    let imageManager = ImageFileManager.sharedInstance
    
    let localDefaults = UserDefaults.standard
    /* WedgetContents, ImageFile **/
    let groupDefaults = UserDefaults(suiteName: GroupKeys().suiteName)

    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: WedgetManager = WedgetManager()
    
    /** 0. 스페셜데이: 1개만 (default) / 1. 과거의 오늘 / 2. 랜덤 */
    func setMode(number:Int) {
        localDefaults.set(number, forKey: wedgetLocalKey.mode)
        log.info(message: "wedgetMode 저장 완료 : \(getMode())")
        setContentsInWedget(mode: number)
    }
    
    func setAndGetMode(number:Int) -> Int {
        localDefaults.set(number, forKey: wedgetLocalKey.mode)
        log.info(message: "테마 저장 완료 : \(getMode())")
        setContentsInWedget(mode: number)
        return getMode()
    }
    
    /** 0. 스페셜데이: 1개만 (default) / 1. 과거의 오늘 / 2. 랜덤 */
    func getMode() -> Int {
        if localDefaults.value(forKey: wedgetLocalKey.mode) == nil {
            return setAndGetMode(number: 0)
        }
        return localDefaults.value(forKey: wedgetLocalKey.mode) as! Int
    }
    
    /** 0. 스페셜데이: 1개만 (default) / 1. 과거의 오늘 / 2. 랜덤 */
    func setContentsInWedget(mode:Int) {
        var diary:Diary? = nil
        
        if haveBeforeImage() {
            deleteBeforeImage()
        }
        if haveBeforeWedgetID() {
            deleteBeforeWedgetID()
        }
        
        if (mode == 0) {
            // 특별한 날 가져오기
            diary = specialDay()
            if nil == diary {
                saveEmptyContents(contents: "기억하고 싶은 날을\n위젯으로 설정해보세요.")
                return;
            }
        }
        if (mode == 1) {
            // 과거의 오늘
            diary = todayOfPast()
            if nil == todayOfPast() {
                saveEmptyContents(contents: "과거의 오늘 일기가 없습니다.")
                return;
            }
        }
        if (mode == 2) {
            // 랜덤
            diary = getRandom()
            if nil == getRandom() {
                saveEmptyContents(contents: "일기장이 비어있습니다.")
                return;

            }
            // cheesing 유료 위젯 멤버 업데이트용
//            if true == (specialDayRepository.isChargedMember()) {
//                let specialDayList = specialDayRepository.getAll()
//                saveForVIP(specialDays: specialDayList)
//                return;
//            }
        }
        
        saveWedgetID(id: (diary?.id)!)
        saveContents(contents: (diary?.content)!, date: diary?.timeStamp)
        saveImage(imageName: diary?.imageName)
//        saveID(id: ??) chessing
        log.info(message: "getWedgetContents : \(getWedgetContents())")
    }
    
    private func getRandom() -> Diary? {
        let idAll = diaryRepository.getIdAll()
        if nil != idAll {
            let lastIndex = (idAll?.count)! - 1
            let randomNo = arc4random_uniform(UInt32(lastIndex))// 0 ~ lastIndex
            let randomId = idAll![Int(randomNo)]
            let selectDiary = diaryRepository.findOne(id: randomId)!
            log.info(message: "Random Dairy Content:\(selectDiary.content)")
            return selectDiary
        }
        return nil
    }
    
    private func todayOfPast() -> Diary? {
        var selectDiary = Diary()
        let allDate = Array(diaryRepository.getAllByTheDate().keys)
        let today = TimeInterval().now()
        let pastTodayDate = today.minusYear(yearAmount: 1).getYYMMDD()
        var todayOfPast:[Diary] = []
        for date in allDate {
            if date == pastTodayDate {
                todayOfPast = diaryRepository.getAllByTheDate()[date]!
            }
        }
        
        if 0 < todayOfPast.count {
            let lastIndex = todayOfPast.count - 1
            let randomIndex = Int(arc4random_uniform(UInt32(lastIndex)))// 0 ~ lastIndex
            selectDiary = todayOfPast[randomIndex]
            return selectDiary
        }
        log.info(message: " 과거의 오늘 \n \(TimeInterval().now().minusYear(yearAmount: 1).getYYMMDD()) \n 일기가 없습니다.")
        return nil
    }
    
    
    private func specialDay() -> Diary? {
        let specialDayList = specialDayRepository.getAll()
        if 0 < specialDayList.count {
            let sepcialDayID = specialDayList[0].diaryID
            let selectDiary = diaryRepository.findOne(id: sepcialDayID)
            return selectDiary
        }
        return nil
    }
    
    func isSpecialDayMode() -> Bool {
        if 0 == getMode() {
            return true
        }
        return false
    }
    
    // -- cheesing
    private func saveForVIP(specialDays:[SpecialDay]) {
        
        // 원래 있던 그룹 디폴트 object들 다 지우는 코드 추가
        
        /*
         let fristContents:String? = nil
         let fristImageName:String? = nil
         let secondContents:String? = nil
         let secondImageName:String? = nil
         
         if 0 == specialDays.count {
         
         }
         if 1 == specialDays.count {
         
         }
         if 2 == specialDays.count {
         
         }
         
         */
    }
    
    private func saveWedgetID(id:Int) {
        groupDefaults?.set(id, forKey: wedgetGroupKey.nowWedgetID)
        log.info(message: " get nowWedgetID : \(String(describing: groupDefaults?.value(forKey: wedgetGroupKey.nowWedgetID)))")
    }
    
    private func saveEmptyContents(contents:String) {
        groupDefaults?.set(contents, forKey: wedgetGroupKey.contents)
    }
    
    private func saveContents(contents:String, date:TimeInterval?) {
        var saveDate:String? = nil
        if date != nil {
            saveDate = date?.getDateLongStyle()
        }
        let newContents = cutContents(contents: contents, date: saveDate)
        log.info(message: newContents)
        groupDefaults?.set(newContents, forKey: wedgetGroupKey.contents)
    }
    
    private func cutContents(contents:String, date:String?) -> String {
        
        let oneLineMax = getTextMaxCharactersCountToLabelWidth(maxWidth: getSreenWidth()*0.6, systemFontSize: WedgetFont().size)
        
        var result = ""
        // 한 줄인 경우
        if contents.characters.count <= oneLineMax {
            result = contents
        }
        else {
            // 한줄 이상인 경우 (30자만 보내기)
            var newContents = contents
            if 30 < contents.characters.count {
                let newContentIndex = contents.index(contents.startIndex, offsetBy: 30)
                newContents = contents.substring(to: newContentIndex)
            }
            let removeBlankContents = removeIndent(contents: newContents)
            let fristLast = Int(CGFloat(oneLineMax) * 0.7)
            let fristIndex = removeBlankContents.index(removeBlankContents.startIndex, offsetBy: fristLast)
            let frist = removeBlankContents.substring(to: fristIndex)
            var etc = removeBlankContents.substring(from: fristIndex)// 자르고 나머지
            let etcCount = etc.characters.count
            if oneLineMax < etcCount {
                let etcIndex = removeBlankContents.index(etc.startIndex, offsetBy: oneLineMax - 4)
                etc = etc.substring(to: etcIndex)
                etc += "..."
            }
            let fixConents = "\(frist)\n\(etc)"
            result = fixConents
        }
        
        if date != nil {
            return "\(result)\n\n\(date!)"
        }
        return result
    }
    
    private func getTextMaxCharactersCountToLabelWidth(maxWidth:CGFloat, systemFontSize:CGFloat) -> Int {
        let exam = UILabel()
        exam.font = UIFont.systemFont(ofSize: systemFontSize)
        exam.text = "벽"
        exam.sizeToFit()
        
        let oneTextWidth = exam.frame.width
        
        log.info(message: "maxWidth - \(maxWidth) oneTextWidth - \(oneTextWidth)   result - \((maxWidth / oneTextWidth))")
        return Int(maxWidth / oneTextWidth)
    }
    
    
    private func getSreenWidth() -> CGFloat {
        let bounds = UIScreen.main.bounds
        let width = bounds.size.width
        log.info(message: "UIScreen.main.bounds - \(UIScreen.main.bounds)")
        return width
    }
    
    private func removeIndent(contents:String) -> String {
        if " " == contents.characters.first {
            let newContentIndex = contents.index(contents.startIndex, offsetBy: 1)
            return contents.substring(from: newContentIndex)
        }
        return contents
    }
    
    
    private func saveImage(imageName:String?) {
        if nil != imageName {
            let image = imageManager.showImage(imageName: imageName!)
            let imageData = UIImagePNGRepresentation(image!)
            groupDefaults?.set(imageData, forKey: wedgetGroupKey.image)
//            log.info(message: " get wedgetImage : \(groupDefaults?.value(forKey: wedgetGroupKey.image))")
        }
    }
    
    func saveTheme(theme:Int) {
        if theme == getNowWedgetTheme() {
            return;
        }
        groupDefaults?.set(theme, forKey: wedgetGroupKey.theme)
    }
    
    private func getNowWedgetTheme() -> Int? {
        if nil != groupDefaults?.value(forKey: wedgetGroupKey.theme) {
            return groupDefaults?.value(forKey: wedgetGroupKey.theme) as? Int
        }
        return nil
    }
    
    private func deleteBeforeImage() {
        groupDefaults?.removeObject(forKey: wedgetGroupKey.image)
    }
    
    private func haveBeforeImage() -> Bool {
        if nil == groupDefaults?.value(forKey: wedgetGroupKey.image) {
            return false
        }
        return true
    }
    
    private func haveBeforeWedgetID() -> Bool {
        if nil == groupDefaults?.value(forKey: wedgetGroupKey.nowWedgetID) {
            return false
        }
        return true
    }
    
    private func deleteBeforeWedgetID() {
        groupDefaults?.removeObject(forKey: wedgetGroupKey.nowWedgetID)
        log.info(message: "delete wedget id -> getNowWedgetID - \(getNowWedgetID())")
    }
    
    func getNowWedgetID() -> Int? {
        if ((groupDefaults?.value(forKey: wedgetGroupKey.nowWedgetID)) != nil) {
            return groupDefaults?.value(forKey: wedgetGroupKey.nowWedgetID) as? Int
        }
        return nil
    }
    
    /* 잘 들어갔는지 로그 확인 용 --- 전체 wdget 데이터 보는 용으로 바꾸기 cheesing**/
    private func getWedgetContents() -> String {
        if let groupDefaults = UserDefaults(suiteName: wedgetGroupKey.suiteName),
            let data = groupDefaults.value(forKey: wedgetGroupKey.contents) as? String {
            return data
        }
        return "위젯 설정 내용 없음"
    }
    
    
    private func haveOpenKeyToWedget() -> Bool? {
        if let groupDefaults = UserDefaults(suiteName: wedgetGroupKey.suiteName),
            let data = groupDefaults.value(forKey: wedgetGroupKey.comeIntoTheWedget) as? Bool {
            return data
        }
        return nil
    }
    
    func isComeIntoTheWedget() -> Bool {
        if true == haveOpenKeyToWedget() {
            return true
        }
        return false
    }
    
    func setOpenAppNormalMode() {
        let groupDefaults = UserDefaults(suiteName: GroupKeys().suiteName)
        groupDefaults?.set(false, forKey: wedgetGroupKey.comeIntoTheWedget)
    }
    

}
