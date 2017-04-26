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
            sliver()
        }
        if theme == 2 {
            cottonCandy()
        }
        if theme == 3 {
            cherryBlossoms()
        }
        if theme == 4 {
            fall()
        }
        if theme == 5 {
            ocean()
        }
    }
    
    func basic() {
        cover = .darkGray
        bar = .darkGray
        tint = UIColor.white.withAlphaComponent(0.7)
        special = UIColor(rgb: 0xebebeb)
        paper = .white
    }
    
    func sliver() {
        bar = UIColor(rgb: 0xc1c0c1)
        cover = bar
        tint = UIColor.white.withAlphaComponent(0.7)
//        date = UIColor(rgb: 0xdedede)
        special = UIColor(rgb: 0xd6d6d6)
        paper = UIColor(rgb: 0xdedede)
    }
    
    func cherryBlossoms() {
        bar = UIColor(rgb: 0xFAA4C8)
        cover = bar
        tint = .white
//        date = UIColor(rgb: 0xfacbe2)
        special = UIColor(rgb: 0xffeef1)
//        paper = UIColor(rgb: 0xF9F9FF)
        paper = UIColor(rgb: 0xfacbe2)
    }
    
    func fall() {
        bar = UIColor(rgb: 0x746D5B)
        cover = bar
        tint = UIColor(rgb: 0x323232)
//        date = UIColor(rgb: 0x9E967F)
        special = UIColor(rgb: 0xCBC19E).withAlphaComponent(0.7)
//        paper = UIColor(rgb: 0xEAEAEA)
        paper = UIColor(rgb: 0x9E967F)
    }
    
    func cottonCandy() {
        bar = UIColor(rgb: 0xC7B3F2)
        cover = bar
        tint = .white
//        date = UIColor(rgb: 0xE4F4FF)
        special = UIColor(rgb: 0x62D9D9).withAlphaComponent(0.5)
//        paper = UIColor(rgb: 0xF9F9FF)
        paper = UIColor(rgb: 0xE4F4FF)
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
    
    
}
