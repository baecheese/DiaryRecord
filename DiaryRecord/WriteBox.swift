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
    let fontSize:CGFloat = 14.0
}

class WriteBox: UIView {
    
    var writeSapce = UITextView()
    var wirteframe = WriteFrame()

    override init(frame: CGRect) {
        super.init(frame: frame)
        makeWriteBox()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeWriteBox() {
        writeSapce = UITextView(frame: self.bounds)
        writeSapce.layer.borderColor = UIColor.lightGray.cgColor
        writeSapce.layer.borderWidth = 0.5
        writeSapce.isEditable = true
        // 줄간격
        let attributedString = NSMutableAttributedString(string: "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = wirteframe.lineSpace
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        writeSapce.attributedText = attributedString
        // 텍스트뷰 상단 떨어지지 않게
        writeSapce.contentOffset = CGPoint.zero
        writeSapce.translatesAutoresizingMaskIntoConstraints = false
        // 폰트 및 크기
        writeSapce.font = UIFont(name: "NanumMyeongjo", size: wirteframe.fontSize)
        self.addSubview(writeSapce)
    }
    
}
