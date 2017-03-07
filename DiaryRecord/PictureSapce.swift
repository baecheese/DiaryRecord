//
//  PictureSapce.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 3..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct PictureSapceFrame {
    let menuHight:CGFloat = 50.0
}

/**  사진과 그림을 추가할 수 있는 뷰 */
class PictureSapce: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeMenu()
        showPicture()
    }
    
    func makeMenu() {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        
    }
    
    func showPicture() {
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}
