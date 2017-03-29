//
//  SpecialDay.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 29..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import Foundation
import RealmSwift

/** SpecialDay은 dairy의 ID만 저장해놓음 */
class SpecialDay: Object {
    dynamic var diaryID:Int = 0
}
