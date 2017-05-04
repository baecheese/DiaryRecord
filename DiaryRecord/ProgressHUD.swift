//
//  ProgressHUD.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 5. 4..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class ProgressHUD: UIVisualEffectView {
    
    var text: String? {
        didSet {
            label.text = text
        }
    }
    
    let activityIndictor: UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
    let label: UILabel = UILabel()
    let blurEffect = UIBlurEffect(style: .light)
    let vibrancyView: UIVisualEffectView
    
    init(text: String) {
        self.text = text
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(effect: blurEffect)
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.text = ""
        self.vibrancyView = UIVisualEffectView(effect: UIVibrancyEffect(blurEffect: blurEffect))
        super.init(coder: aDecoder)
        self.setup()
    }
    
    func setup() {
        contentView.addSubview(vibrancyView)
        contentView.addSubview(activityIndictor)
        contentView.addSubview(label)
    }
    
    let activityIndicatorSize: CGFloat = 40
    let height: CGFloat = 50.0
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if let superview = self.superview {
            
            let width = superview.frame.size.width
            self.frame = CGRect(x: superview.frame.size.width / 2 - width / 2,
                                y: superview.frame.height / 2 - height / 2,
                                width: width,
                                height: height)
            vibrancyView.frame = self.bounds
            
            activityIndictor.frame = CGRect(x: 5,
                                            y: height / 2 - activityIndicatorSize / 2,
                                            width: activityIndicatorSize,
                                            height: activityIndicatorSize)
            
            layer.cornerRadius = 8.0
            layer.masksToBounds = true
            
            label.text = text
            label.font = UIFont.boldSystemFont(ofSize: 10)
            label.sizeToFit()
            label.frame.origin = CGPoint(x: activityIndicatorSize + 5, y: height/2 - label.frame.height/2)
            label.textAlignment = NSTextAlignment.left
            label.textColor = UIColor.gray
            label.backgroundColor = .yellow
            
        }
    }
    
    func show(message:String) {
        activityIndictor.startAnimating()
        changeLabel(text: message)
        self.isHidden = false
    }
    
    func changeLabel(text:String) {
        label.text = text
        label.font = UIFont.boldSystemFont(ofSize: 10)
        label.sizeToFit()
        label.frame.origin = CGPoint(x: activityIndicatorSize + 5, y: height/2 - label.frame.height/2)
    }
    
    func hide() {
        activityIndictor.stopAnimating()
        self.isHidden = true
    }

}
