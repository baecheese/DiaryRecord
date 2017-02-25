//
//  CardView.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 15..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct CardFrame {
    var dateLabelHight:CGFloat = 30
    var contentFontSize:CGFloat = 15
    var contentlineSpacing:CGFloat = 10
    var dateFontSize:CGFloat = 10
    
}

class CardView: UIView {
    
    var contentTextView = UITextView()
    var date = UILabel()
    let cardFrame = CardFrame()
    var dateHight = CardFrame().dateLabelHight
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeContentsTextView()
        makeDateLabel()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeContentsTextView() {
        contentTextView = UITextView(frame: CGRect(x: 0, y: dateHight, width: self.frame.width, height: self.frame.height - dateHight))
        contentTextView.layer.borderColor = UIColor.lightGray.cgColor
        contentTextView.layer.borderWidth = 0.5
        contentTextView.isEditable = false// 컨텐츠 수정 불가 모드가 default
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
    
    func makeDateLabel() {
        date = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: dateHight))
        date.layer.borderColor = UIColor.blue.cgColor
        date.layer.borderWidth = 0.5
        date.font = UIFont(name: "NanumMyeongjo", size: cardFrame.dateFontSize)
        date.textAlignment = NSTextAlignment.right
        self.addSubview(date)
    }
    
}
