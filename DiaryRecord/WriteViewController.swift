//
//  WriteViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct WriteFrame {
    var margen:CGFloat = 30.0
    var margenOnKeyborad:CGFloat = 40.0
}

private extension Selector {
    static let keyboardWillShow = #selector(WriteViewController.keyboardWillShow(notification:))
}


class WriteViewController: UIViewController {
    
    let log = Logger.init(logPlace: WriteViewController.self)
    @IBOutlet var background: UIView!
    var contentTextView: UITextView!
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    let writeFrame = WriteFrame()
    var keyboardHeight:CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpObserver()
        makeContentsTextView(keyboardHeight: keyboardHeight)
        contentTextView.becomeFirstResponder()
        
    }
    
    @IBAction func clickSaveButton(_ sender: UIBarButtonItem) {
        
        showActivityIndicatory(start: true)
        
        // 날짜 및 내용 realm 저장
        let nowTimeStamp = TimeInterval().now()
        
        let diaryRepo = DiaryRepository()
        let trySaveDiary:(Bool, String) = diaryRepo.save(timeStamp: nowTimeStamp, content: contentTextView.text)// (저장결과, 메세지)
        
        let saveSuccess = trySaveDiary.0
        let saveMethodResultMessage = trySaveDiary.1
        
        if false == saveSuccess {
            showActivityIndicatory(start: false)
            showAlert(message: saveMethodResultMessage)
        }
        else {
            // 저장 성공 시
            sendSaveMessage(succese: true)
            showActivityIndicatory(start: false)
            disappearPopAnimation()
        }
    }
    
    func sendSaveMessage(succese:Bool) {
        let viewControllers:Array = (self.navigationController?.viewControllers)!
        let beforeVC:MainTableViewController = viewControllers.first as! MainTableViewController
        beforeVC.saveNewDairy = true
    }
    
    /* UI & 애니메이션 */
    
    func makeContentsTextView(keyboardHeight: CGFloat) {
        if (0 != keyboardHeight) {
            /* Frame */
            self.contentTextView.frame.size.width = background.frame.width - writeFrame.margen
            self.contentTextView.frame.size.height -= (writeFrame.margen + writeFrame.margenOnKeyborad + keyboardHeight)
        }
        else {
            // height는 background 높이를 기준으로 계산하니 자꾸 오차가 나서 [루트 뷰 높이 - 네비 높이] 로 계산
            contentTextView = UITextView(frame: CGRect(x: writeFrame.margen, y: writeFrame.margen, width: background.frame.width, height: self.view.frame.size.height - (self.navigationController?.navigationBar.frame.size.height)!))
            
            contentTextView.backgroundColor = UIColor.brown
            
            /* 텍스트뷰 상단 떨어지지 않게 */
            self.automaticallyAdjustsScrollViewInsets = false
            contentTextView.contentOffset = CGPoint.zero
            
            // 줄간격
            let attributedString = NSMutableAttributedString(string: " ")
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 10.0
            attributedString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
            contentTextView.attributedText = attributedString
            // 폰트 및 크기
            contentTextView.font = UIFont(name: "NanumMyeongjo", size: 15)
            
            self.background.addSubview(contentTextView)
        }
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
    
    
    /* NSNotification - 키보드 높이 구하기 */
    
    private func setUpObserver() {
        NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: .UIKeyboardWillShow, object: nil)
    }
    
    @objc fileprivate func keyboardWillShow(notification:NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.keyboardHeight = keyboardRectValue.height
            self.viewDidLoad()
        }
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
