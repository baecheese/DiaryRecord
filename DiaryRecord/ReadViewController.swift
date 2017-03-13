//
//  ReadViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController {

    private let log = Logger.init(logPlace: ReadViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    var diary = Diary()
    @IBOutlet var backgroundView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSelectedDairy()
        
        // 추후 테마 넣으면 변수 바꾸기
        showContent(themeNumber: 0)
        
    }
    
    /* 필요한 data */
    func getSelectedDairy() {
        diary = diaryRepository.findOne(id: SharedMemoryContext.get(key: "seletedDiaryID") as! Int)!
    }
    
    /* contents setting 관련 */
    
    func showContent(themeNumber:Int) {
        if themeNumber == 0 {
            makeContentCard(date: diary.timeStamp.getDateString(), content: diary.content, imagPath:diary.imagePath)
        }
    }
    
    func makeContentCard(date: String, content:String, imagPath:String?) {
        let margen:CGFloat = 30.0
        let contentWidth = self.view.frame.size.width - (margen * 2)
        let contentHeight = self.view.frame.size.height - (margen * 4)
        
        let card = CardView(frame: CGRect(x: margen, y: margen, width: contentWidth, height: contentHeight), imagPath: imagPath)
        
        card.contentTextView.text = content
        card.date.text = date
        card.contentTextView.contentOffset = CGPoint.zero
        
        if imagPath != nil {
            if FileManager.default.fileExists(atPath: imagPath!) {
                let url = NSURL(string: imagPath!)
                let data = NSData(contentsOf: url! as URL)
                card.imageBox.image = UIImage(data: data! as Data)
            }
            else {
                log.info(message: "사진 파일 없음")
            }
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        self.backgroundView.addSubview(card)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
