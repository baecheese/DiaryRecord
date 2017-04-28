//
//  ColorManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 28..
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

class ColorManager: NSObject {
    
    init(theme:Int) {
        super.init()
        selectTheme(theme: theme)
    }
    
    var background = UIColor()
    let textBackground = UIColor.black.withAlphaComponent(0.6)
    let text = UIColor.black
    
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
        background = .darkGray
    }
    
    func sliver() {
        background = UIColor(rgb: 0xc1c0c1)
    }
    
    func cherryBlossoms() {
        background = UIColor(rgb: 0xFAA4C8)
    }
    
    func fall() {
        background = UIColor(rgb: 0x746D5B)
    }
    
    func cottonCandy() {
        background = UIColor(rgb: 0xC7B3F2)
    }
    
    func ocean() {
        background = UIColor(rgb: 0x375d81)
    }
}
