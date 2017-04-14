//
//  WriteBox.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 28..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct WriteFrame {
    var lineSpace:CGFloat = 10.0
    let fontSize:CGFloat = 17.0
}

extension UIViewController : UITextViewDelegate {
    
    /** 키보드 위 toolBar */
    func addToolBar(textField: UITextView, barTintColor:UIColor, tintColor:UIColor) {
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        
        toolBar.barTintColor = barTintColor
        toolBar.tintColor = tintColor
        
        let galleryButton = UIBarButtonItem(image: #imageLiteral(resourceName: "gallery.png"), style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.photoPressed))
        let cancelButton = UIBarButtonItem(image: #imageLiteral(resourceName: "down.png"), style: UIBarButtonItemStyle.done, target: self, action: #selector(UIViewController.cancelPressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil)
        toolBar.setItems([cancelButton, spaceButton, galleryButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        textField.delegate = self
        textField.inputAccessoryView = toolBar
    }
    
    func photoPressed() {
        
    }
    
    func cancelPressed() {
        
    }
}

class WriteBox: UIView, UITextViewDelegate {
    
    let log = Logger.init(logPlace: WriteBox.self)
    var writeSpace = UITextView()
    var writeframe = WriteFrame()
    var imageView = UIImageView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeWriteBox()
        writeSpace.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeWriteBox() {
        writeSpace = UITextView(frame:CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        writeSpace.isEditable = true
        let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
        writeSpace.backgroundColor = colorManager.paper
        // 줄간격
        let attributedString = NSMutableAttributedString(string: " ")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = writeframe.lineSpace
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        writeSpace.attributedText = attributedString
        // 텍스트뷰 상단 떨어지지 않게
        writeSpace.contentOffset = CGPoint.zero
        writeSpace.translatesAutoresizingMaskIntoConstraints = false
        // 폰트 및 크기
        writeSpace.font = UIFont(name: "NanumMyeongjo", size: writeframe.fontSize)
        // 키보드 자동완성 turn off
        writeSpace.autocorrectionType = UITextAutocorrectionType.no
        self.addSubview(writeSpace)
    }
    
}
