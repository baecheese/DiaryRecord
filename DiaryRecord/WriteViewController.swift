//
//  WriteViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

private extension Selector {
    static let keyboardWillShow = #selector(WriteViewController.keyboardWillShow(notification:))
}

struct WriteState {
    let margen:CGFloat = 30.0
    let margenOnKeyborad:CGFloat = 30.0
    var keyboardHeight:CGFloat = 0.0
    var writeMode = true
    var frist = 0
}

class WriteViewController: UIViewController {
    
    let log = Logger.init(logPlace: WriteViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    
    @IBOutlet var background: UIView!
    var writeBox = WriteBox()
    var writeState = WriteState()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpObserver()
        writeState.frist += 1
    }
    
    override func viewWillLayoutSubviews() {
        makeWriteBox()
        writeBox.writeSapce.becomeFirstResponder()
        changeHight(writeMode: writeState.writeMode)
    }
    
    @IBAction func clickSaveButton(_ sender: UIBarButtonItem) {
        
        showActivityIndicatory(start: true)
        
        // 날짜 및 내용 realm 저장
        let nowTimeStamp = TimeInterval().now()
        
        // (저장결과, 메세지)
        let trySaveDiary:(Bool, String) = diaryRepository.save(timeStamp: nowTimeStamp, content: contentTextView.text)
        
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
        SharedMemoryContext.changeValue(key: "saveNewDairy", value: true)
    }
    
    @IBAction func handleTapGesture(_ sender: UITapGestureRecognizer) {
        log.info(message: "🍔 tap")
        writeBox.resignFirstResponder()
        changeHight(writeMode: false)
    }
    
    
    /* UI & 애니메이션 */
    
    func makeWriteBox() {
        let writeWidth = self.view.frame.size.width - (writeState.margen * 2)
        let writeHeight = self.view.frame.size.height - (writeState.margen * 4)
        
        writeBox = WriteBox(frame: CGRect(x: writeState.margen, y: writeState.margen, width: writeWidth, height: writeHeight))
        self.automaticallyAdjustsScrollViewInsets = false
        background.addSubview(writeBox)
    }
    
    func changeHight(writeMode:Bool) {
        let writeBoxHeight = writeBox.frame.size.height
        if true == writeMode {
            // 쓰기 모드일 때 키보드 높이 빼기
        }
        else {
            if 1 != writeState.frist {
                // 쓰기모드 아니고, 처음이 킨 것이 아닐 때 원래대로
            }
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
        if 0.0 == writeState.keyboardHeight {
            NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: .UIKeyboardWillShow, object: nil)
        }
    }
    
    @objc fileprivate func keyboardWillShow(notification:NSNotification) {
        if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            writeState.keyboardHeight = keyboardRectValue.height
            writeState.writeMode = true
            self.viewWillLayoutSubviews()
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
