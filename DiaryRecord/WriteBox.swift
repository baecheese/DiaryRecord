//
//  WriteBox.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 28..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct WriteFrame {
    var margen:CGFloat = 30.0
    var margenOnKeyborad:CGFloat = 30.0
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
        // 뷰에서는 꽉 차게 하고, controller에서 margen 주기 --- cheesing
        writeSapce = UITextView(frame: CGRect(x: wirteframe.margen, y: wirteframe.margen, width: (wirteframe.margen)*2, height: (wirteframe.margen)*2))
        writeSapce.layer.borderColor = UIColor.lightGray.cgColor
        writeSapce.layer.borderWidth = 0.5
        writeSapce.isEditable = true
        // 줄간격
        let attributedString = NSMutableAttributedString(string: "temp text")
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
