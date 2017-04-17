//
//  EmailManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 17..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class EmailManager: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: EmailManager = EmailManager()
    let defaults = UserDefaults.standard
    let log = Logger(logPlace: EmailManager.self)
    
    func set(email:String) {
        defaults.set(email, forKey: "email")
        log.info(message: "이메일 저장 완료 : \(get())")
    }
    
    func setAndGet(email:String) -> String? {
        defaults.set(email, forKey: "email")
        log.info(message: "이메일 저장 완료 : \(get())")
        return get()
    }
    
    func get() -> String? {
        if defaults.value(forKey: "email") == nil {
            return nil
        }
        return defaults.value(forKey: "email") as? String
    }
    
    func isValidEmail(email:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: email)
    }

    
}
