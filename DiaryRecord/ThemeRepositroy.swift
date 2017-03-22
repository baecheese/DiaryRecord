//
//  ThemeRepositroy.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 22..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class ThemeRepositroy: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: ThemeRepositroy = ThemeRepositroy()
    let defaults = UserDefaults.standard
    let log = Logger(logPlace: ThemeRepositroy.self)
    
    func set(number:Int) {
        defaults.set(number, forKey: "theme")
        log.info(message: "테마 저장 완료 : \(get())")
    }
    
    func setAndGet(number:Int) -> Int {
        defaults.set(number, forKey: "theme")
        log.info(message: "테마 저장 완료 : \(get())")
        return get()
    }
    
    func get() -> Int {
        if defaults.value(forKey: "theme") == nil {
            return setAndGet(number: 0)
        }
        return defaults.value(forKey: "theme") as! Int
    }
    
}
