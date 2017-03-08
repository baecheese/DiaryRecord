//
//  SharedContext.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 25..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

public enum Optional<T> {
    case None
    case Some(T)
}


/**
 사용 중인 key : "seletedDiaryID"(Int), "saveNewDairy"(Bool), "navigationbarHeight"(CGFloat)
 */
public struct SharedMemoryContext {
    
    private static var context:[String:Any] = Dictionary()
    
    public static func get(key:String) -> Any {
        let arrayOfKeys = Array(context.keys)
        if (arrayOfKeys.contains(key)) {
            return context[key]!
        }
        else {
            if key == "seletedDiaryID" {
                return Optional<Int>.None
            }
            if key == "saveNewDairy" {
                return Optional<Bool>.None
            }
            return Optional<CGFloat>.None
        }
    }
    
    public static func set(key:String, setValue:Any) {
        context.updateValue(setValue, forKey: key)
    }
    
    public static func setAndGet(key:String, setValue:Any) -> Any {
        context.updateValue(setValue, forKey: key)
        return setValue
    }
    
    public static func changeValue(key:String, value:Any) {
        context[key] = value
    }
    
}
