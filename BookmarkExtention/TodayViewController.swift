//
//  TodayViewController.swift
//  BookmarkExtention
//
//  Created by 배지영 on 2017. 3. 24..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

struct GroupKeys {
    let suiteName = "group.com.baecheese.DiaryRecord"
    let contents = "WedgetContents"
    let image = "ImageFile"
}

struct WedgetStatus {
    let fontName = "NanumMyeongjo"
    let fontSize:CGFloat = 15.0
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var label: UILabel!
    @IBOutlet var backgroundImage: UIImageView!
    
    let groupKeys = GroupKeys()
    let wedgetStatus = WedgetStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWedgetSize()
        setContent()
        setBackImage()
    }
    
    func setWedgetSize() {
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
        }
        // wedget max size memo : float maxHeight = [[ UIScreen mainScreen ] bounds ].size.height - 126;
    }
    
    func setContent() {
        label.text = getData()
        label.font = UIFont(name: "NanumMyeongjo", size: 10.0)// 안됨
    }
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0.0, height: 200.0)
        } else if activeDisplayMode == .compact {
            preferredContentSize = maxSize
        }
    }
    
    func setBackImage() {
        if nil != getImage() {
            backgroundImage.image = getImage()
        }
        else {
            backgroundImage.image = UIImage(named: "wedget.jpg")
        }
    }
    
    func getImage() -> UIImage? {
        if let groupDefaults = UserDefaults(suiteName: groupKeys.suiteName),
            let data = groupDefaults.value(forKey: groupKeys.image) as? Data {
            let image = UIImage(data: data)
            return image
        }
        return nil
    }
    
    
    func getData() -> String {
        if let groupDefaults = UserDefaults(suiteName: groupKeys.suiteName),
            let data = groupDefaults.value(forKey: groupKeys.contents) as? String {
            print(data)
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
