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
}

class CardView: UIView {
    
    // 날짜 넣을 수 잇는 라벨 만들기 ---
    // 폰트, 줄 간격 설정
    
    var contentTextView = UITextView()
    var date = UILabel()
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
        contentTextView.backgroundColor = UIColor.red// 추후 삭제 ---
        contentTextView.isEditable = false// 컨텐츠 수정 불가 모드가 default
        contentTextView.font = UIFont(name: "NanumMyeongjo", size: 30)
        self.addSubview(contentTextView)
    }
    
    func makeDateLabel() {
        date = UILabel(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: dateHight))
        date.backgroundColor = UIColor.blue
        self.addSubview(date)
    }
    
}
