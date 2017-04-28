//
//  SendContentsManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 28..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct GroupKeys {
    let suiteName = "group.com.baecheese.DiaryRecord"
    let contents = "WedgetContents"
    let date = "Date"
    let image = "ImageFile"
    let theme = "theme"
}

struct WedgetMessage {
    let empty = "설정된 일기가 없습니다."
}

class SendContentsManager: NSObject {
    
    let groupKeys = GroupKeys()
    let message = WedgetMessage()
    
    override init() {
        super.init()
    }
    
    func haveImage() -> Bool {
        if getImage() == nil {
            return false
        }
        return true
    }
    
    func getImage() -> UIImage? {
        if let groupDefaults = UserDefaults(suiteName: groupKeys.suiteName),
            let data = groupDefaults.value(forKey: groupKeys.image) as? Data {
            let image = UIImage(data: data)
            return image
        }
        return nil
    }
    
    func getWedgetContent() -> String {
        let textEditor = TextEditor()
        let editText = textEditor.getOrganizedContents(content: getContentData(), date: getDate())
        return editText
    }
    
    private func getContentData() -> String {
        if let groupDefaults = UserDefaults(suiteName: groupKeys.suiteName),
            let data = groupDefaults.value(forKey: groupKeys.contents) as? String {
            return data
        }
        return message.empty
    }
    
    private func getDate() -> String? {
        if let groupDefaults = UserDefaults(suiteName: groupKeys.suiteName),
            let data = groupDefaults.value(forKey: groupKeys.date) as? String {
            return data
        }
        return nil
    }
    
    func getTheme() -> Int {
        if let groupDefaults = UserDefaults(suiteName: groupKeys.suiteName),
            let data = groupDefaults.value(forKey: groupKeys.theme) as? Int {
            return data
        }
        return 0
    }
    
}
