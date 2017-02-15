//
//  ReadViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class ReadViewController: UIViewController {

    @IBOutlet var contentsTextView: UITextView!

    let log = Logger.init(logPlace: ReadViewController.self)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeContentsTextView()
        showSelectedDairy()
    }
    
    func showSelectedDairy() {
        let mainVC = getMainVC()
        let diary = DiaryRepository().getDiary(id: mainVC.seletedDiaryID)
        log.info(message: "\(diary.id) \(diary.timeStamp) \(diary.content)")
    }
    
    func getMainVC() -> MainTableViewController {
        let viewControllers:Array = (self.navigationController?.viewControllers)!
        let beforeVC:MainTableViewController = viewControllers.first as! MainTableViewController
        return beforeVC
    }
    
    func makeContentsTextView() {
        /* 텍스트뷰 상단 떨어지지 않게 */
        self.automaticallyAdjustsScrollViewInsets = false
        contentsTextView.contentOffset = CGPoint.zero
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
