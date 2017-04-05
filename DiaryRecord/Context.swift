//
//  SharedContext.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 25..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/**
 사용 중인 key : "selectedDiaryID"(Int), "saveNewDairy"(Bool), "navigationbarHeight"(CGFloat), "isWriteMode"(Bool)
 */
public struct SharedMemoryContext {
    
    private static var context:[String:Any?] = Dictionary()
    
    public static func get(key:String) -> Any? {
        if context[key] == nil {
            return nil
        }
        return context[key]!
    }
    
    public static func set(key:String, setValue:Any) {
        if context[key] != nil {
            changeValue(key: key, value: setValue)
            return;
        }
        context.updateValue(setValue, forKey: key)
    }
    
    public static func setAndGet(key:String, setValue:Any) -> Any {
        if context[key] != nil {
            changeValue(key: key, value: setValue)
            return setValue
        }
        context.updateValue(setValue, forKey: key)
        return setValue
    }
    
    public static func changeValue(key:String, value:Any) {
        context[key] = value
    }
    
}
