//
//  WriteBox.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 28..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct WriteFrame {
    var lineSpace:CGFloat = 20.0
    let fontSize:CGFloat = 17.0
}

protocol WriteBoxDelegate {
    func onTouchUpInsideWriteSpace()
}

class WriteBox: UIView, UITextViewDelegate {
    
    let log = Logger.init(logPlace: WriteBox.self)
    var writeSpace = UITextView()
    var writeframe = WriteFrame()
    var delegate:WriteBoxDelegate?

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
        writeSpace.layer.borderColor = UIColor.lightGray.cgColor
        writeSpace.layer.borderWidth = 0.5
        writeSpace.isEditable = true
        // 줄간격
        let attributedString = NSMutableAttributedString(string: "")
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = writeframe.lineSpace
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        writeSpace.attributedText = attributedString
        // 텍스트뷰 상단 떨어지지 않게
        writeSpace.contentOffset = CGPoint.zero
        writeSpace.translatesAutoresizingMaskIntoConstraints = false
        // 폰트 및 크기
        writeSpace.font = UIFont(name: "NanumMyeongjo", size: writeframe.fontSize)
        self.addSubview(writeSpace)
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        writeSpace.resignFirstResponder()
        usingTexiView()
        return true
    }
    
    func usingTexiView() {
        delegate?.onTouchUpInsideWriteSpace()
    }
    
}
