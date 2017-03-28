//
//  ImageBox.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 24..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

protocol ImageBoxDelegate {
    func deleteImage()
}

class ImageBox: UIView {
    let log = Logger(logPlace: ImageBox.self)
    var imageSpace = UIImageView()
    var delegate:ImageBoxDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        makeImageBox(frame: frame)
        makeImageDeleteButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeImageBox(frame: CGRect) {
        imageSpace.frame = self.bounds
        imageSpace.isUserInteractionEnabled = true
        self.addSubview(imageSpace)
    }
    
    func makeImageDeleteButton() {
        let margen:CGFloat = 5.0
        let deleteSize:CGFloat = 38.0
        let deleteButton = UIButton(frame: CGRect(x: self.frame.size.width - deleteSize - margen, y: margen, width: deleteSize, height: deleteSize))
        let no = UIImage(named: "no")
        deleteButton.setImage(no, for: .normal)
        deleteButton.tintColor = .white
        deleteButton.addTarget(self, action: #selector(ImageBox.clickButton), for: .touchUpInside)
        self.addSubview(deleteButton)
    }
    
    func clickButton() {
        log.info(message: "click deleteImage button")
        self.delegate?.deleteImage()
    }
}
