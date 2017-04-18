//
//  EmailManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 17..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import MessageUI

class EmailManager: NSObject, MFMailComposeViewControllerDelegate {
    
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
    
    func delete() {
        defaults.set(nil, forKey: "email")
    }
    
    func sendNewPassword(newPassword:String) {
        // 새로운 비번 설정된 이메일에 보내기
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([get()!])
            mail.setMessageBody("<p> new password : \(newPassword) </p>", isHTML: true)
//            present(mail, animated: true)????????????????? 키체인으로 설정된건 설정에서볼수있다. --> 키체인공부필요 cheesing
        } else {
            // show failure alert
        }
    }
}
