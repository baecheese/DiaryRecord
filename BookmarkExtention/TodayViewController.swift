//
//  TodayViewController.swift
//  BookmarkExtention
//
//  Created by 배지영 on 2017. 3. 24..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit
import NotificationCenter

struct WedgetStatus {
    let fontName = "NanumMyeongjo"
    let fontSize:CGFloat = 15.0
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let wedgetStatus = WedgetStatus()
    let contentManager = SendContentsManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setWedgetSize()
        setBackground()
        setContents()
    }
    
    func setWedgetSize() {
        if #available(iOSApplicationExtension 10.0, *) {
            extensionContext?.widgetLargestAvailableDisplayMode = .expanded
        } else {
            // Fallback on earlier versions
        }
        // wedget max size memo : float maxHeight = [[ UIScreen mainScreen ] bounds ].size.height - 126;
    }
    
    
    func widgetActiveDisplayModeDidChange(_ activeDisplayMode: NCWidgetDisplayMode, withMaximumSize maxSize: CGSize) {
        if activeDisplayMode == .expanded {
            preferredContentSize = CGSize(width: 0.0, height: 200.0)
        } else if activeDisplayMode == .compact {
            preferredContentSize = maxSize
        }
    }
    
    var backImage = UIImageView()
    
    func setBackground() {
        if true == contentManager.haveImage() {
            backImage.frame = self.view.bounds
            backImage.image = contentManager.getImage()
            view.addSubview(backImage)
        }
        else {
            let colorManger = ColorManager(theme: contentManager.getTheme())
            view.backgroundColor = colorManger.background
        }
    }
    
    func setContents() {
        let label = UILabel(frame: CGRect(x: 10, y: 10, width: 100, height: 100))
        label.backgroundColor = .red
        label.text = "123123"
        
        if true == contentManager.haveImage() {
            backImage.addSubview(label)
        }
        else {
            view.addSubview(label)
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
