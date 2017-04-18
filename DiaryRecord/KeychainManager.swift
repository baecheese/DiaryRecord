//
//  KeychainManager.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 14..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct KeychainKey {
    let password = "password"
    let secretQuestion = "question"
    let secretAnswer = "answer"
}

class KeychainManager: NSObject {
    
    private override init() {
        super.init()
    }
    
    static let sharedInstance: KeychainManager = KeychainManager()
    
    private let log = Logger(logPlace: KeychainManager.self)
    private let keychain = Keychain()
    private let key = KeychainKey()
    
    func savePassword(value:String) {
        if haveBeforePassword() {
           deletePassword()
        }
        let passwordData = value.data(using: .utf8)
        keychain.save(withKey: key.password, andData: passwordData)
    }
    
    func haveBeforePassword() -> Bool {
        if loadPassword() != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func isRightPassword(password:String) -> Bool {
        let passwordData = password.data(using: .utf8)
        let savedPassword = loadPassword()
        if passwordData == savedPassword {
            log.info(message: "right")
            return true
        }
        else {
            log.info(message: "dont right")
            return false
        }
    }
    
    func loadPassword() -> Data? {
        let passwordData = keychain.load(withKey: key.password)
        if passwordData == nil {
            return nil
        }
        return passwordData as Data?
    }
    
    func deletePassword() {
        keychain.delete(withKey: key.password)
        log.info(message: "loadPassword : \(loadPassword())")
    }
    
    func resetPassword() -> String {
        savePassword(value: "1111")
        // 새로운 암호 저장하고 리턴 ing
        return "1111"
    }
    
    /* SecretQNA */
    
    func saveSecretQNA(question:String, answer:String) {
        if haveBeforeSecrectQNA() {
            deleteSecrectQNA()
        }
        let questionData = question.data(using: .utf8)
        let answerData = answer.data(using: .utf8)
        keychain.save(withKey: key.secretQuestion, andData: questionData)
        keychain.save(withKey: key.secretAnswer, andData: answerData)
    }
    
    
    func haveBeforeSecrectQNA() -> Bool {
        if loadSecrectQNA() != nil {
            return true
        }
        else {
            return false
        }
    }
    
    func isRightSecrectQNA(question:String, answer:String) -> Bool {
        let secrectQNA:(Data, Data) = (question.data(using: .utf8)!, answer.data(using: .utf8)!)
        let savedQNA = loadSecrectQNA()
        if savedQNA == nil {
            log.info(message: "have not saved QNA")
            return false
        }
        if secrectQNA == savedQNA! {
            log.info(message: "right")
            return true
        }
        else {
            log.info(message: "dont right")
            return false
        }
    }
    
    func loadSecrectQNA() -> (Data, Data)? {
        let question = keychain.load(withKey: key.secretQuestion)
        let answer = keychain.load(withKey: key.secretAnswer)
        if question == nil || answer == nil {
            return nil
        }
        return (question!, answer!)
    }
    
    func deleteSecrectQNA() {
        keychain.delete(withKey: key.secretQuestion)
        keychain.delete(withKey: key.secretAnswer)
        log.info(message: "loadSecrectQNA : \(loadSecrectQNA())")
    }
    
}
