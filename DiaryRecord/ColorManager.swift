//
//  ColorManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 19..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** 0: basic */
class ColorManager: NSObject {
    
    init(theme:Int) {
        super.init()
        selectTheme(theme: theme)
    }
    
    var bar = UIColor()
    var tint = UIColor()
    var title = UIColor()
    var date = UIColor()
    var paper = UIColor()
    
    func selectTheme(theme:Int) {
        if theme == 1 {
            cherryBlossoms()
        }
        else {
            basic()
        }
    }
    
    func basic() {
        bar = UIColor(red: 25.0/255, green: 52.0/255, blue: 65.0/255, alpha: 1.0)
        tint = UIColor(red: 209.0/255, green: 219.0/255, blue: 189.0/255, alpha: 1.0)
        title = UIColor.white
        date = UIColor(red: 62.0/255, green: 96.0/255, blue: 111.0/255, alpha: 1.0)
        paper = UIColor(red: 252.0/255, green: 255.0/255, blue: 245.0/255, alpha: 1.0)
    }
    
    func cherryBlossoms() {
        bar = UIColor(red: 255.0/255, green: 66.0/255, blue: 66.0/255, alpha: 1.0)
        tint = UIColor(red: 255.0/255, green: 225.0/255, blue: 208.0/255, alpha: 1.0)
        title = UIColor.black
        date = UIColor(red: 255.0/255, green: 131.0/255, blue: 126.0/255, alpha: 1.0)
        paper = UIColor(red: 255.0/255, green: 191.0/255, blue: 180.0/255, alpha: 1.0)
    }
    
}
