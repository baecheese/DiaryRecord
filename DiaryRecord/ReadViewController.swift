//
//  ReadViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController {

    let log = Logger.init(logPlace: ReadViewController.self)
    var diary = Diary()
    
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSelectedDairy()
        
        // 추후 테마 넣으면 변수 바꾸기
        showContent(themeNumber: 0)
    }
    
    func showContent(themeNumber:Int) {
        if themeNumber == 0 {
            makeContentCard(content: diary.content)
        }
    }
    
    func makeContentCard(content:String) {
        let margen:CGFloat = 30.0
        let contentWidth = self.view.frame.size.width - (margen * 2)
        let contentHeight = self.view.frame.size.height - margen
        
        let card = CardView(frame: CGRect(x: margen, y: margen, width: contentWidth, height: contentHeight))
        card.contentTextView.text = content
        card.contentTextView.contentOffset = CGPoint.zero
        self.automaticallyAdjustsScrollViewInsets = false
        self.backgroundView.addSubview(card)
    }
    
    func getSelectedDairy() {
        let mainVC = getMainVC()
        diary = DiaryRepository().getDiary(id: mainVC.seletedDiaryID)
        log.info(message: "\(diary.id) \(diary.timeStamp) \(diary.content)")
        
    }
    
    func getMainVC() -> MainTableViewController {
        let viewControllers:Array = (self.navigationController?.viewControllers)!
        let beforeVC:MainTableViewController = viewControllers.first as! MainTableViewController
        return beforeVC
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
