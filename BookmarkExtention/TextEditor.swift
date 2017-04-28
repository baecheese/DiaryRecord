//
//  TextEditor.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 28..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class TextEditor: NSObject {
    
    override init() {
        super.init()
    }
    
    func getOrganizedContents(content:String, date:String?) -> String {
        let maxContentWidth = 100
        let oneTextWidth = 10
        if content.characters.count * oneTextWidth < maxContentWidth {
            return "\(content) \n \n\(date)"
        }
        else {
//            content를 반 쪼개서 큰 쪽이 아래로 작은 쪽이 위로 + 아랫 줄 날짜
        }
        
        return ""
    }
}
