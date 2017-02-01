//
//  WriteViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class WriteViewController: UIViewController {

    @IBOutlet var contentsTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeContentsTextView()
        
    }
    
    func makeContentsTextView() {
        /* 텍스트뷰 상단 떨어지지 않게 */
        self.automaticallyAdjustsScrollViewInsets = false
        contentsTextView.contentOffset = CGPoint.zero
    }
    
    func makeDate() -> String {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        
        return dateFormatter.string(from: now as Date)
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
