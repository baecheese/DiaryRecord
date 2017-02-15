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
    
    var contentTextView = UITextView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeContentsTextView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func makeContentsTextView() {
        contentTextView = UITextView(frame: CGRect(x: 0, y: 0, width: 400, height: 400))
        contentTextView.backgroundColor = UIColor.red
        self.addSubview(contentTextView)
        /* 텍스트뷰 상단 떨어지지 않게 */
    }
    
}
