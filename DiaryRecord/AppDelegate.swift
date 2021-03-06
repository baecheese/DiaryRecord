//
//  AppDelegate.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    private let log = Logger(logPlace: AppDelegate.self)
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        SharedMemoryContext.set(key: "saveNewDairy", setValue: false)
        let keychain = KeychainManager.sharedInstance
        if keychain.loadPassword() != nil {
            if true == keychain.haveBeforePassword() {
                keychain.deletePassword()
                SharedMemoryContext.set(key: "isSecretMode", setValue: false)
            } else {
                SharedMemoryContext.set(key: "isSecretMode", setValue: true)
            }
        }
        if keychain.loadPassword() == nil {
            SharedMemoryContext.set(key: "isSecretMode", setValue: false)
        }
        
        let fontManager = FontManager.sharedInstance
        fontManager.changeSize(sizeMode: fontManager.getSizeMode())
//        fontManager.changeSize(sizeMode: 3)
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if true == haveSelectDiaryInWedget() {
            setSelectDiaryInfo()
            let navigationController = self.window?.rootViewController as? UINavigationController
            navigationController?.popToRootViewController(animated: true)
        }
        return true
    }
    
    let wedgetManager = WedgetManager.sharedInstance
    let diaryRepository = DiaryRepository.sharedInstance
    
    func haveSelectDiaryInWedget() -> Bool {
        if true == wedgetManager.isComeIntoTheWedget() && nil != wedgetManager.getNowWedgetID() {
            return true
        }
        return false
    }
    
    func setSelectDiaryInfo() {
        let info = diaryRepository.getDiaryInfo(diaryID: wedgetManager.getNowWedgetID()!)
        SharedMemoryContext.set(key: "selectedDiaryInfo", setValue: (info.0, info.1))
    }
}

