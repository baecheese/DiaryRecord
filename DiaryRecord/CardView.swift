//
//  CardView.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 15..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct CardFrame {
    var contentLabelHeight:CGFloat = 0
    var dateLabelHight:CGFloat = 60.0
    var contentlineSpacing:CGFloat = 10.0
    let imageHeight:CGFloat = 200.0
    let mainMargen:CGFloat = 30.0
    let subMargen:CGFloat = 20.0
}

class CardView: UIView {
    
    let log = Logger.init(logPlace: CardView.self)
    
    var backScrollView = UIScrollView()
    private var date = UILabel()
    private var contentsLabel = UILabel()
    private var cardFrame = CardFrame()
    private var imageSection = UIImageView()
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let imageManager = ImageFileManager.sharedInstance
    private let fontmanager = FontManager.sharedInstance
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func makeReadView(date:String, content:String, imageName:String?) {
        makeBackground()
        makeContentLabel(content: content, imageName: imageName)
        changeContentsSize(imageName: imageName)
    }
    
    func changingDiary() {
        for view in self.subviews {
            view.removeFromSuperview()
        }
        makeBackground()
    }
    
    func showChangedDiaryContents(content:String, imageName:String?) {
        makeContentLabel(content: content, imageName: imageName)
        changeContentsSize(imageName: imageName)
    }
    
    private func makeBackground() {
        backScrollView = UIScrollView(frame: CGRect(x: 0, y: 0, width: self.frame.size.width, height: self.frame.size.height))
        backScrollView.contentSize = CGSize(width: self.frame.width, height: self.frame.height)
        backScrollView.isScrollEnabled = true
        backScrollView.backgroundColor = colorManager.paper
        
        self.addSubview(backScrollView)
    }
    
    func makeContentLabel(content:String, imageName:String?) {
        if (nil == imageName) {
            contentsLabel = UILabel(frame: CGRect(x: cardFrame.mainMargen, y: cardFrame.mainMargen, width: self.frame.width - cardFrame.mainMargen * 2, height: 60))// height는 바꿀 값
        }
        else if (nil != imageName) {
            makeImageSection(image: imageManager.showImage(imageName: imageName!)!)
            contentsLabel = UILabel(frame: CGRect(x: cardFrame.mainMargen, y: cardFrame.subMargen + cardFrame.imageHeight, width: self.frame.width - cardFrame.mainMargen * 2, height: 60))// height는 바꿀 값
        }
        
//        contentsLabel.backgroundColor = .red
        contentsLabel.backgroundColor = colorManager.paper
        
        // 줄간격
        let attributedString = NSMutableAttributedString(string: content)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = cardFrame.contentlineSpacing
        attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        contentsLabel.attributedText = attributedString
        // 폰트 및 크기
        contentsLabel.font = UIFont(name: fontmanager.pageTextFont, size: fontmanager.pageTextSize)
        
        contentsLabel.numberOfLines = 0
        contentsLabel.lineBreakMode = NSLineBreakMode.byWordWrapping
        contentsLabel.sizeToFit()
        // 새로 얻은 label height
        cardFrame.contentLabelHeight = contentsLabel.frame.size.height
        
        backScrollView.addSubview(contentsLabel)
        
    }
    
    private func setChangeTextAnimation () {
        if true == SharedMemoryContext.get(key: "moveDiaryInReadPage") as? Bool {
            contentsLabel.alpha = 0.0
        }
    }
    
    private func makeImageSection(image:UIImage) {
        imageSection = UIImageView(frame: CGRect(x: 0, y: 0, width: self.frame.width, height: cardFrame.imageHeight))
        imageSection.image = image
        imageSection.contentMode = .scaleAspectFill
//        imageSection.contentMode = .scaleAspectFit
        imageSection.clipsToBounds = true
        backScrollView.addSubview(imageSection)
    }
    
    private func makeDateLabel(dateText:String, imageName:String?) {
        date = UILabel(frame: CGRect(x: 0, y: cardFrame.mainMargen + cardFrame.contentLabelHeight, width: self.frame.width - cardFrame.mainMargen, height: cardFrame.dateLabelHight))
        
        if (imageName != nil) {
            date.frame.origin.y += cardFrame.imageHeight
        }
        
        /*
         date.layer.borderColor = UIColor.blue.cgColor
         date.layer.borderWidth = 0.5
        */
        
        date.text = dateText
        date.font = UIFont(name: fontmanager.pageTextFont, size: fontmanager.headerTextSize)
        date.textAlignment = NSTextAlignment.right
        date.backgroundColor = colorManager.paper
        backScrollView.addSubview(date)
    }
    
    private func changeContentsSize(imageName:String?) {
       backScrollView.contentSize.height = cardFrame.mainMargen * 3 + cardFrame.contentLabelHeight + cardFrame.dateLabelHight + cardFrame.subMargen
        if imageName != nil {
            backScrollView.contentSize.height += cardFrame.imageHeight
        }
    }
    
}
