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
    
}
