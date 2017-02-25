//
//  SharedContext.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 25..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

public struct SharedMemoryContext {
    
    private static var context:[String:Any] = Dictionary()
    
    public static func get(key:String) -> Any {
        return context[key]!
    }
    
    public static func set(key:String, setValue:Any) {
        context.updateValue(setValue, forKey: key)
    }
    
    public static func setAndGet(key:String, setValue:Any) -> Any {
        context.updateValue(setValue, forKey: key)
        return setValue
    }
    
}
