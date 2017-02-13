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
        contentsTextView.text = String(mainVC.seletedDiaryID)
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
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
