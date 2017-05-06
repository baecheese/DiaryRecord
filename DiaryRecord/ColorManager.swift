//
//  ColorManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 19..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
    
}

/** 0: basic */
class ColorManager: NSObject {
    
    init(theme:Int) {
        super.init()
        selectTheme(theme: theme)
    }
    
    var cover = UIColor()
    var bar = UIColor()
    var tint = UIColor()
    var title = UIColor.black
//    var date = UIColor()
    var paper = UIColor()// 합칠 예정
    
    var special = UIColor()
    
    var mainText = UIColor.black
    var subText = UIColor.gray
    
    /** 테마 번호 0. basic 1. sliver 2. cotton candy 3. cherry blossoms 4. fall 5. ocean */
    func selectTheme(theme:Int) {
        if theme == 0 {
            basic()
        }
        if theme == 1 {
            spring()
        }
        if theme == 2 {
            cherryBlossoms()
        }
        if theme == 3 {
            jos()
        }
        if theme == 4 {
            ocean()
        }
        if theme == 5 {
            snow()
        }
    }
    
    func basic() {
        cover = UIColor(rgb: 0x404040)
        bar = .darkGray
        tint = UIColor.white.withAlphaComponent(0.7)
        special = UIColor(rgb: 0x9cc6d4)
        paper = UIColor(rgb: 0xe4edf0)
    }
    
    func spring() {
        cover = UIColor(rgb: 0xf29c9c)
        bar = UIColor(rgb: 0xf3b59b)
        tint = .white
        special = UIColor(rgb: 0xf3e59a)
        paper = UIColor(rgb: 0xf3f0d6)
    }
    
    func cherryBlossoms() {
        bar = UIColor(rgb: 0xFAA4C8)
        cover = bar
        tint = .white
//        date = UIColor(rgb: 0xfacbe2)
        special = UIColor(rgb: 0xffe2f1)
//        paper = UIColor(rgb: 0xF9F9FF)
        paper = UIColor(rgb: 0xfff4fd)
    }
    
    func jos() {
        bar = UIColor(rgb: 0x685c79)
        cover = bar
        title = UIColor(rgb: 0x00374b)
        tint = .white
        special = UIColor(rgb: 0xDa727e)
        //        paper = UIColor(rgb: 0xF9F9FF)
        paper = UIColor(rgb: 0xac8690)
    }
    
    func ocean() {
        bar = UIColor(rgb: 0x375d81)
        cover = bar
        tint = .white
//        date = UIColor(rgb: 0xabc8e2)
        special = UIColor(rgb: 0xc4d7ed)
//        paper = UIColor(rgb: 0xe1e6fa)
        paper = UIColor(rgb: 0xabc8e2)
    }
    
    func snow() {
        cover = .white
        bar = .white
        title = .darkGray
        tint = .lightGray
        special = UIColor(rgb: 0xC4D7ED)
        paper = .white
    }
    
    
}
