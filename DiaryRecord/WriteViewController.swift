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
    
    @IBAction func clickSaveButton(_ sender: UIBarButtonItem) {
        
        // 인디케이터 --
        
        // 내용 및 날짜 저장 --
        
        disappearPopAnimation()
        
    }
    

    /* Data 관련 */
    
    func makeDate() -> String {
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        dateFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        
        return dateFormatter.string(from: now as Date)
    }
    
    
    /* UI & 애니메이션 */
    
    func makeContentsTextView() {
        /* 텍스트뷰 상단 떨어지지 않게 */
        self.automaticallyAdjustsScrollViewInsets = false
        contentsTextView.contentOffset = CGPoint.zero
    }
    
    func disappearPopAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popToRootViewController(animated: false)
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
