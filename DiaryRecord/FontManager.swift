//
//  FontManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 24..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct FontKey {
    let fontSize = "fontSize"
}

/* 0. 작게 / 1. 중간 (default) / 2. 크게 / 3. 아주 크게 **/
class FontManager: NSObject {
    
    private let key = FontKey()
    private let localDefaults = UserDefaults.standard
    private let log = Logger(logPlace: FontManager.self)
    
    let naviTitleFontSize:CGFloat = 20.0
    let naviItemFontSize:CGFloat = 15.0
    var headerTextSize:CGFloat = 0.0
    var cellTextSize:CGFloat = 0.0
    var cellSubTextSize:CGFloat = 0.0
    var pageTextSize:CGFloat = 0.0
    
    let sizeList = ["작게", "중간", "크게", "아주 크게"]
    let naviTitleFont:String = "SeoulHangangM"
    let headerFont:String = "SeoulHangangM"
    let cellFont:String = "NanumMyeongjo"
    let cellSubFont:String = "SeoulHangangM"
    var pageTextFont:String = "NanumMyeongjo"
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: FontManager = FontManager()
    
    func setSizeMode(number:Int) {
        localDefaults.set(number, forKey: key.fontSize)
        log.info(message: "fontSize 저장 완료 : \(getSizeMode())")
        changeSize(sizeMode: getSizeMode())
    }
    
    func setAndGetSizeMode(number:Int) -> Int {
        localDefaults.set(number, forKey: key.fontSize)
        log.info(message: "fontSize 저장 완료 : \(getSizeMode())")
        return getSizeMode()
    }
    
    func getSizeMode() -> Int {
        if localDefaults.value(forKey: key.fontSize) == nil {
            return setAndGetSizeMode(number: 1)
        }
        return localDefaults.value(forKey: key.fontSize) as! Int
    }
    
    func changeSize(sizeMode:Int) {
        if 0 == sizeMode {
            headerTextSize = 10.0
            cellTextSize = getCellSizeToMode(mode: sizeMode)// 15
            cellSubTextSize = 10.0
            pageTextSize = getCellSizeToMode(mode: sizeMode)
        }
        if 1 == sizeMode {
            headerTextSize = 11.0
            cellTextSize = getCellSizeToMode(mode: sizeMode)
            cellSubTextSize = 11.0
            pageTextSize = getCellSizeToMode(mode: sizeMode)
        }
        if 2 == sizeMode {
            headerTextSize = 13.0
            cellTextSize = getCellSizeToMode(mode: sizeMode)
            cellSubTextSize = 12.0
            pageTextSize = getCellSizeToMode(mode: sizeMode)
        }
        if 3 == sizeMode {
            headerTextSize = 15.0
            cellTextSize = getCellSizeToMode(mode: sizeMode)
            cellSubTextSize = 13.0
            pageTextSize = getCellSizeToMode(mode: sizeMode)
        }
    }
    
    func getCellSizeToMode(mode:Int) -> CGFloat {
        if 0 == mode {
            return 15.0
        }
        if 1 == mode {
            return 20.0
        }
        if 2 == mode {
            return 25.0
        }
        if 3 == mode {
            return 30.0
        }
        return 20.0
    }
}
