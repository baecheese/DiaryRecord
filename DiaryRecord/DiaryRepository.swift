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
    
    override init() {
        super.init()
    }
    
    func saveDiaryToRealm(data:String, time:String, content:String) {
        
        let diary = Diary()
        let realm = try! Realm()
        do {
            try realm.write {
                diary.data = data
                diary.time = time
                diary.content = content
            }
        } catch {
            print("error on")
        }
        
    }
    
//    func getDiarys() -> ??? {
//    // 일기 목록들 가져오기
//    // realm 쿼리 날리는 걸로 가져오게 하면 됨
//    // section이 날짜별로 분류되니, 날짜에 따른 컨텐츠 나오게 하면 될듯
//    }
    
}
