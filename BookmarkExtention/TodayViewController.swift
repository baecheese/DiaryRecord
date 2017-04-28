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

struct wedgetFont {
    let size:CGFloat = 13.0
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let wedgetStatus = WedgetStatus()
    let contentManager = SendContentsManager()
    let font = wedgetFont()
    
    @IBOutlet var background: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        setWedgetSize()
        setBackground()
        setContents()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        changeTextView()
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
        changeTextViewToOffsetY(wedgetHeight: preferredContentSize.height)
    }
    
    var backImage = UIImageView()
    
    func setBackground() {
        if true == contentManager.haveImage() {
            backImage.frame = self.view.bounds
            backImage.image = contentManager.getImage()
            backImage.contentMode = .scaleAspectFill//
            background.addSubview(backImage)
        }
        else {
            let colorManger = ColorManager(theme: contentManager.getTheme())
            background.backgroundColor = colorManger.background
        }
    }
    
    private let textview = UITextView(frame: CGRect(x: 0, y: 0, width: 200, height: 100))
    
    func setContents() {
        textview.font = UIFont.systemFont(ofSize: font.size)
        textview.text = contentManager.getContentData()
        textview.alpha = 0.0
        if true == contentManager.haveImage() {
            backImage.addSubview(textview)
        }
        else {
            background.addSubview(textview)
        }
    }
    
    func changeTextView() {
        textview.sizeToFit()
        textview.alpha = 1.0
        let colorManger = ColorManager(theme: contentManager.getTheme())
        textview.textColor = colorManger.text
        textview.backgroundColor = colorManger.textBackground
        
        let textWidth = textview.frame.width
        let textHeight = textViewHeightToSizeFit()
        
        let offsetX:CGFloat = (background.frame.width/2) - (textWidth/2)
        let offsetY:CGFloat = (background.frame.height/2) - (textHeight/2)
        
        textview.frame = CGRect(x: offsetX, y: offsetY, width: textWidth, height: textHeight)

    }
    
    func changeTextViewToOffsetY(wedgetHeight:CGFloat) {
        UIView.animate(withDuration: 0.3, delay: 0.2, options: .curveEaseOut, animations: {
            let offsetY:CGFloat = (wedgetHeight/2) - (self.textViewHeightToSizeFit()/2)
            self.textview.frame.origin.y = offsetY
        }, completion: nil)
        
    }
    
    private func textViewHeightToSizeFit() -> CGFloat {
        textview.sizeToFit()
        return textview.frame.height
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
}
