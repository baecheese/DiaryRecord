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
    
    let log = Logger.init(logPlace: CardView.self)
    
    var backScrollView = UIScrollView()
    var date = UILabel()
    let cardFrame = CardFrame()
    var dateHight = CardFrame().dateLabelHight
    var imageSection = UIImageView()
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let imageManager = ImageFileManager.sharedInstance
    
    init(frame: CGRect, date:String, content:String, imageName:String?) {
        super.init(frame: frame)
        makeBackground()
        makeContentsTextView(content: content, imageName: imageName)
        makeDateLabel(dateText: date)
        changeContentsSize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func makeBackground() {
        backScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        backScrollView.contentSize = CGSize(width: self.frame.width, height: self.frame.height * 2)
        backScrollView.isScrollEnabled = true
        backScrollView.backgroundColor = .gray
        self.addSubview(backScrollView)
    }
    
    func makeContentsTextView(content:String, imageName:String?) {
        
        var contentsLabel = UILabel()
        if (nil == imageName) {
            contentsLabel = UILabel(frame: CGRect(x: cardFrame.margen, y: cardFrame.dateLabelHight + cardFrame.margen, width: self.frame.width - cardFrame.margen * 2, height: 60))// height는 바꿀 값
        }
        else if (nil != imageName) {
            makeImageSection(image: imageManager.showImage(imageName: imageName!)!)
            contentsLabel = UILabel(frame: CGRect(x: cardFrame.margen, y: cardFrame.imageHeight + cardFrame.dateLabelHight, width: self.frame.width - cardFrame.margen * 2, height: 60))// height는 바꿀 값
        }
        
        contentsLabel.backgroundColor = .red
        
        // 줄간격
        let attributedString = NSMutableAttributedString(string: content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = cardFrame.contentlineSpacing
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        contentsLabel.attributedText = attributedString
        // 폰트 및 크기
        contentsLabel.font = UIFont(name: "NanumMyeongjo", size: cardFrame.contentFontSize)
        
        contentsLabel.numberOfLines = 0
        contentsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentsLabel.sizeToFit()
        
        backScrollView.addSubview(contentsLabel)
    }
    
    func makeImageSection(image:UIImage) {
        imageSection = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width / 2, height: cardFrame.imageHeight))
        imageSection.image = image
        imageSection.contentMode = .scaleAspectFill
        imageSection.clipsToBounds = true
        backScrollView.addSubview(imageSection)
    }
    
    func makeDateLabel(dateText:String) {
        date = UILabel(frame: CGRect(x: 0, y: cardFrame.imageHeight, width: self.frame.width, height: dateHight))
        /*
         date.layer.borderColor = UIColor.blue.cgColor
         date.layer.borderWidth = 0.5
         */
        date.text = dateText
        date.font = UIFont(name: "NanumMyeongjo", size: cardFrame.dateFontSize)
        date.textAlignment = NSTextAlignment.right
        date.backgroundColor = colorManager.paper
        backScrollView.addSubview(date)
    }
    
    func changeContentsSize() {
       // backScrollView.contentSize.height = contentTextView.contentSize.height + imageSection.frame.size.height + date.frame.size.height
    }
    
}
