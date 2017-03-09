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
    let margenOnKeyborad:CGFloat = 60.0
    var writeBoxHeight:CGFloat = 0.0
    var writeSpaceHeight:CGFloat = 0.0
    var keyboardHeight:CGFloat = 0.0
    
    var isFrist:Bool = true
}

class WriteViewController: UIViewController, WriteBoxDelegate {
    
    let log = Logger.init(logPlace: WriteViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    
    @IBOutlet var backgroundScroll: UIScrollView!
    var writeBox = WriteBox()
    var writeState = WriteState()
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* UI 및 기능 세팅 */
        setUpObserver()
        makeWriteBox()
        setBackgroundContentsSize()
        makeBackButton()
    }
    
    override func viewWillLayoutSubviews() {
        writeBox.writeSpace.becomeFirstResponder()
    }
    
    /* action */
    
    @IBAction func clickSaveButton(_ sender: UIBarButtonItem) {
        
        showActivityIndicatory(start: true)
        
        // 날짜 및 내용 realm 저장
        let nowTimeStamp = TimeInterval().now()
        
        // (저장결과, 메세지)
        let trySaveDiary:(Bool, String) = diaryRepository.save(timeStamp: nowTimeStamp, content: writeBox.writeSpace.text)
        
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
    
    // save 관련 SharedMemoryContext 메세지 전달
    func sendSaveMessage(succese:Bool) {
        SharedMemoryContext.changeValue(key: "saveNewDairy", value: true)
    }
    
    func onTouchUpInsideWriteSpace() {
        log.info(message: "🍔 up")
        writeBox.writeSpace.endEditing(false)
    }
    
    func clickBackButton() {
        log.info(message: "🍔 click Back Button")
        writeBox.writeSpace.endEditing(true)
    }
    
    /* UI & 애니메이션 */
    
    func getNavigationBarHeight() -> CGFloat {
        let naviHeight = SharedMemoryContext.get(key: "navigationbarHeight")
        if nil == naviHeight {
            return SharedMemoryContext.setAndGet(key: "navigationbarHeight", setValue: self.navigationController!.navigationBar.frame.height) as! CGFloat
        }
        else {
            return naviHeight as! CGFloat
        }
    }
    
    func makeWriteBox() {
        let writeWidth = self.view.frame.size.width - (writeState.margen * 2)
        writeState.writeBoxHeight = self.view.frame.size.height - (writeState.margen + getNavigationBarHeight()) // 네비 빼야함
        
        writeBox = WriteBox(frame: CGRect(x: writeState.margen, y: writeState.margen, width: writeWidth, height: writeState.writeBoxHeight))
        // textview 높이 설정
        writeState.writeSpaceHeight = writeState.writeBoxHeight - (writeState.keyboardHeight + writeState.margenOnKeyborad)
        writeBox.writeSpace.frame.size.height = writeState.writeSpaceHeight
        writeBox.backgroundColor = .blue
        self.automaticallyAdjustsScrollViewInsets = false

        addToolBar(textField: writeBox.writeSpace)
        writeBox.delegate = self
        
        backgroundScroll.addSubview(writeBox)
    }
    
    func setBackgroundContentsSize() {
        backgroundScroll.contentSize = CGSize(width: self.view.frame.size.width, height: writeState.writeBoxHeight)
    }
    
    func makeBackButton() {
        let width = self.view.frame.size.width
        let height = self.backgroundScroll.contentSize.height
        let up = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: writeState.margen))
        let right = UIButton(frame: CGRect(x: width - writeState.margen, y: 0, width: writeState.margen, height: height))
        let left = UIButton(frame: CGRect(x: 0, y: 0, width: writeState.margen, height: height))
        
        up.backgroundColor = .red
        right.backgroundColor = .black
        left.backgroundColor = .yellow
        
        let buttonArray = [up, right, left]
        
        for button in buttonArray {
            button.addTarget(self, action: #selector(WriteViewController.clickBackButton), for: .touchUpInside)
            backgroundScroll.addSubview(button)
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
            if writeState.isFrist == true {
                writeState.isFrist = false
                makeWriteBox()
            }
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
