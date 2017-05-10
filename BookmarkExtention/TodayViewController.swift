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
    let expandedMaxHeight:CGFloat = 200.0
}

class TodayViewController: UIViewController, NCWidgetProviding {
    
    let wedgetStatus = WedgetStatus()
    let contentManager = SendContentsManager()
    
    @IBOutlet var background: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        background.backgroundColor = .red
        setWedgetSize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if true == changeContents() {
            setBackground()
            setContents()
            changeTextView(contents: contentManager.getContentData())
        }
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
            preferredContentSize = CGSize(width: 0.0, height: wedgetStatus.expandedMaxHeight)
        } else if activeDisplayMode == .compact {
            preferredContentSize = maxSize
        }
        changeTextViewToOffsetY(wedgetHeight: preferredContentSize.height)
    }
    
    var backImage = UIImageView()
    
    func setBackground() {
        backImage.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: wedgetStatus.expandedMaxHeight)
        backImage.contentMode = .scaleAspectFill
        background.addSubview(backImage)
        if true == contentManager.haveImage() {
            backImage.image = contentManager.getImage()
        }
        else {
            backImage.image = UIImage(named: "sky_widgetbackground.png")
        }
    }
    
    private let textview = UITextView()
    
    func setContents() {
        changeTextView(contents: contentManager.getContentData())
        if true == contentManager.haveImage() {
            backImage.addSubview(textview)
        }
        else {
            background.addSubview(textview)
        }
    }
    
    func changeTextView(contents:String) {
        textview.frame.size = CGSize(width: view.frame.width * 0.7, height: 100.0)
        textview.isEditable = false
        
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 2.0
        let attributes = [NSParagraphStyleAttributeName : style]
        textview.attributedText = NSAttributedString(string: contents, attributes:attributes)
        
        textview.font = UIFont.systemFont(ofSize: wedgetStatus.fontSize)
        textview.textAlignment = .center
        let colorManger = ColorManager(theme: contentManager.getTheme())
        textview.textColor = colorManger.text
        textview.backgroundColor = colorManger.textBackground
        
        textview.alpha = 1.0
        
        let textWidth:CGFloat = textViewWidthToSizeFit()
        let textHeight:CGFloat = textViewHeightToSizeFit()
        
        let offsetX:CGFloat = (view.frame.width/2) - (textWidth/2)
        let offsetY:CGFloat = (preferredContentSize.height/2) - (textHeight/2)
        
        textview.frame = CGRect(x: offsetX, y: offsetY, width: textWidth, height: textHeight)
    }
    
    func changeTextViewToOffsetY(wedgetHeight:CGFloat) {
        UIView.animate(withDuration: 0.2, delay: 0.2, options: .curveEaseOut, animations: {
            let offsetY:CGFloat = (wedgetHeight/2) - (self.textViewHeightToSizeFit()/2)
            self.textview.frame.origin.y = offsetY
        }, completion: nil)
        
    }
    
    private func textViewHeightToSizeFit() -> CGFloat {
        textview.sizeToFit()
        return textview.frame.height
    }
    
    private func textViewWidthToSizeFit() -> CGFloat {
        textview.sizeToFit()
        return textview.frame.width
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    func widgetPerformUpdate(completionHandler: (@escaping (NCUpdateResult) -> Void)) {
        completionHandler(NCUpdateResult.newData)
    }
    
    func changeContents() -> Bool {
        if textview.text != contentManager.getContentData() {
            return true
        }
        return false
    }
    
    @IBAction func tapContents(_ sender: UITapGestureRecognizer) {
        contentManager.openAppNotice()
        extensionContext?.open(URL(string: "diaryRecord://")! , completionHandler: nil)
    }
    
}
