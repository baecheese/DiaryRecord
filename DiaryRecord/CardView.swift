//
//  CardView.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 15..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct CardFrame {
    var dateLabelHight:CGFloat = 30.0
    var contentFontSize:CGFloat = 15.0
    var contentlineSpacing:CGFloat = 10.0
    var dateFontSize:CGFloat = 10.0
    let imageHeight:CGFloat = 200.0
    let margen:CGFloat = 30.0
}

class CardView: UIView {
    
    var contentTextView = UITextView()
    var date = UILabel()
    let cardFrame = CardFrame()
    var dateHight = CardFrame().dateLabelHight
    var imageSection = UIImageView()
    let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    
    init(frame: CGRect, imageName:String?) {
        super.init(frame: frame)
        makeContentsTextView(imageName: imageName)
        makeDateLabel()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    func makeDateLabel() {
        date = UILabel(frame: CGRect(x: 0, y: cardFrame.imageHeight, width: self.frame.width, height: dateHight))
        /*
        date.layer.borderColor = UIColor.blue.cgColor
        date.layer.borderWidth = 0.5
         */
        date.font = UIFont(name: "NanumMyeongjo", size: cardFrame.dateFontSize)
        date.textAlignment = NSTextAlignment.right
        date.backgroundColor = colorManager.paper
        self.addSubview(date)
    }

    func makeContentsTextView(imageName:String?) {
        if (nil == imageName) {
            contentTextView = UITextView(frame: CGRect(x: cardFrame.margen, y: cardFrame.dateLabelHight + cardFrame.margen, width: self.frame.width - cardFrame.margen * 2, height: self.frame.height - dateHight))
        }
        else if (nil != imageName) {
            contentTextView = UITextView(frame: CGRect(x: cardFrame.margen, y: cardFrame.imageHeight + cardFrame.dateLabelHight, width: self.frame.width - cardFrame.margen * 2, height: self.frame.height - dateHight - cardFrame.imageHeight - cardFrame.margen))
            makeImageSection()
        }
        contentTextView.backgroundColor = .red
        /*
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 0.5
         */
        contentTextView.isEditable = false// 컨텐츠 수정 불가 모드가 default
        contentTextView.isScrollEnabled = true
        // 줄간격
        let attributedString = NSMutableAttributedString(string: "temp text")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = cardFrame.contentlineSpacing
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        contentTextView.attributedText = attributedString
        // 폰트 및 크기
        contentTextView.font = UIFont(name: "NanumMyeongjo", size: cardFrame.contentFontSize)
        
        self.addSubview(contentTextView)
    }
    
    func makeImageSection() {
        imageSection = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: cardFrame.imageHeight))
//        imageSection.backgroundColor = .red
        imageSection.contentMode = .scaleAspectFill
        imageSection.clipsToBounds = true
        self.addSubview(imageSection)
    }

    
    
}
