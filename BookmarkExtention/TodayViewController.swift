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
    let date = "Date"
    let image = "ImageFile"
}

struct WedgetStatus {
    let fontName = "NanumMyeongjo"
    let fontSize:CGFloat = 15.0
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    @IBOutlet var backgroundImage: UIImageView!

    @IBOutlet var labelTop: UILabel!
    @IBOutlet var labelCenter: UILabel!
    @IBOutlet var labelBottom: UILabel!
    
    let groupKeys = GroupKeys()
    let wedgetStatus = WedgetStatus()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWedgetSize()
        setContentData()
        setLabelStatus()
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
    
    func setLabelStatus() {
        let labels = [labelTop, labelCenter, labelBottom]
        for label in labels {
            label?.font = UIFont(name: wedgetStatus.fontName, size: wedgetStatus.fontSize)
            label?.backgroundColor = UIColor(hue: 0, saturation: 0, brightness: 0, alpha: 0.7)
            label?.textColor = .white
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
    
    
    func setContentData() {
        if let groupDefaults = UserDefaults(suiteName: groupKeys.suiteName),
            let data = groupDefaults.value(forKey: groupKeys.contents) as? String {
            let characters = data.characters
            if characters.count < 16 {
                labelCenter.text = data
                labelTop.text = ""
                setDate()
                return;
            }
            
            var top = ""
            var center = ""
            var count = 0
            
            for character in characters {
                if count <= 13 {
                    top += String(character)
                }
                if 14 <= count && count <= 20 {
                    center += String(character)
                }
                count += 1
            }
            
            center += "..."
            
            labelTop.text = top
            labelCenter.text = center
        }
        setDate()
    }
    
    func setDate() {
        if let groupDefaults = UserDefaults(suiteName: groupKeys.suiteName),
            let date = groupDefaults.value(forKey: groupKeys.date) as? String {
            labelBottom.text = date
        }
        else {
            labelBottom.text = ""
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
