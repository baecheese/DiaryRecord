//
//  Diary.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 1..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import Foundation
import RealmSwift

class Diary: Object {
    
    // data, time
    // : "yyyy-MM-dd" / "HH:mm:ss"
    
    dynamic var dateTimeID:TimeInterval = 0.0
    dynamic var content = ""
    
}
