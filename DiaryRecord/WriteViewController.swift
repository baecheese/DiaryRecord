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
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        makeContentsTextView()
        
    }
    
    @IBAction func clickSaveButton(_ sender: UIBarButtonItem) {
        
        showActivityIndicatory(start: true)
        
        // 날짜 및 내용 realm 저장
        let nowDateId = makeDate().0
        let nowTimeId = makeTime().0
        let nowDate:String = makeDate().1
        let nowTime:String = makeTime().1
        
        let diaryRepo = DiaryRepository()
        let trySaveDiary:(Bool, String) = diaryRepo.saveDiaryToRealm(dateId: nowDateId, timeId: nowTimeId, date: nowDate, time: nowTime, content: contentsTextView.text)// (저장결과, 메세지)
        
        let saveSuccess = trySaveDiary.0
        let saveMethodMessage = trySaveDiary.1
        
        if false == saveSuccess {
            showActivityIndicatory(start: false)
            showAlert(message: saveMethodMessage)
        }
        else {
            // 저장 성공 시
            showActivityIndicatory(start: false)
            disappearPopAnimation()
        }
    }
    

    /* Data 관련 */
    
    func makeDate() -> (Int, String) {
        let now = NSDate()
        
        let dateNumberFormatter = DateFormatter()
        dateNumberFormatter.dateFormat = "yyyyMMdd"
        dateNumberFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        let dateNumber = Int(dateNumberFormatter.string(from: now as Date))
        
        let dateStringFormatter = DateFormatter()
        dateStringFormatter.dateFormat = "yyyy-MM-dd"
        dateStringFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        let dateString = dateStringFormatter.string(from: now as Date)
        
        return (dateNumber!, dateString)
    }
    
    func makeTime() -> (Int, String) {
        let now = NSDate()
        
        let timeNumberFormatter = DateFormatter()
        timeNumberFormatter.dateFormat = "HHmmss"
        timeNumberFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        let timeNumber = Int(timeNumberFormatter.string(from: now as Date))
        
        let timeStrigFormatter = DateFormatter()
        timeStrigFormatter.dateFormat = "HH:mm:ss"
        timeStrigFormatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale!
        let timeString = timeStrigFormatter.string(from: now as Date)
        
        return (timeNumber!, timeString)
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
    
    func showActivityIndicatory(start:Bool) {
        let superViewHeight = self.view.frame.height
        let superViewWidth = self.view.frame.width
        let activityIndicatorSize: CGFloat = 40
        activityIndicator.frame = CGRect(x: superViewWidth / 2 - activityIndicatorSize / 2,
                                         y: superViewHeight / 2 - activityIndicatorSize / 2,
                                         width: activityIndicatorSize,
                                         height: activityIndicatorSize)
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(activityIndicator)
        if true == start {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        
    }
    
    func showAlert(message:String)
    {
        let alertController = UIAlertController(title: "error", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
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
