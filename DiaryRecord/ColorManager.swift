//
//  ColorManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 19..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 1: basic */
class ColorManager: NSObject {
    
    init(theme:Int) {
        super.init()
        selectTheme(theme: theme)
    }
    
    var bar = UIColor()
    var tint = UIColor()
    var title = UIColor()
    
    func selectTheme(theme:Int) {
        if theme == 1 {
            basic()
        }
    }
    
    func basic() {
        bar = UIColor(red: 25.0/255, green: 52.0/255, blue: 65.0/255, alpha: 1.0)
        tint = UIColor(red: 62.0/255, green: 96.0/255, blue: 111.0/255, alpha: 1.0)
        title = UIColor(red: 145.0/255, green: 170.0/255, blue: 157.0/255, alpha: 1.0)
    }
    
    
}
