//
//  CardView.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 15..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class CardView: UIView {
    
    
    // 날짜 넣을 수 잇는 라벨 만들기 ---
    // 폰트, 줄 간격 설정
    
    var contentTextView = UITextView()
    var date = UILabel()
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeContentsTextView()
        makeDateLabel()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeContentsTextView() {
        contentTextView = UITextView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        contentTextView.backgroundColor = UIColor.red
        self.addSubview(contentTextView)
    }
    
    func makeDateLabel() {
        date = UILabel(frame: CGRect(x: 300, y: 300, width: 100, height: 30))
        self.contentTextView.addSubview(date)
    }
    
}
