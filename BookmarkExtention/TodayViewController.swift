//
//  TodayViewController.swift
//  BookmarkExtention
//
//  Created by 배지영 on 2017. 3. 24..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var label: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWedgetSize()
        label.text = getData()
    }
    
    func setWedgetSize() {
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
        }
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0.0, height: 200.0)
        } else if activeDisplayMode == .compact {
            preferredContentSize = maxSize
        }
    }
    
    func setBackImage() {
        if nil == getImage() {
            
        }
    }
    
    func getImage() -> UIImage? {
//        if  {
//            
//        }
        return nil
    }
    
    
    func getData() -> String {
        if let groupDefaults = UserDefaults(suiteName: "group.com.baecheese.DiaryRecord"),
            let data = groupDefaults.value(forKey: "WedgetContents") as? String {
            return data
        }
        return "위젯 설정을 해주세요"
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
