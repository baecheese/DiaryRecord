//
//  SecretQuestionViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 18..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct SecrectQuestionMessage {
    let questions = ["가장 기억에 남는 장소는?", "다시 태어나면 되고 싶은 것은?", "사랑하는 사람의 이름은?", "반려동물의 이름은?", "가장 기억에 남는 영화는?", "가장 좋아하는 책은?"]
    let findMode = "Enter your Secret Q&A."
    let empty = "Please answer."
    let success = "Save was successful."
    let discord = "The secrect Q&A you entered is wrong."
}

class SecretQuestionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private let log = Logger(logPlace: SecretQuestionViewController.self)
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private var selectQuestion = "가장 기억에 남는 장소는?"
    private let keychainManager = KeychainManager.sharedInstance
    private let message = SecrectQuestionMessage()
    
    @IBOutlet var SecretQuestionView: UIView!
    @IBOutlet var question: UIButton!
    @IBOutlet var answer: UITextField!
    
    @IBOutlet var noticeLabel: UILabel!// 찾을 때, 설정할 때 달라야하니까
    @IBOutlet var ok: UIButton!
    @IBOutlet var cancel: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationItem()
        showFindButton()
        showFindNotice()
    }
    
    @IBAction func clickQuestion(_ sender: UIButton) {
        showPickerInActionSheet()
    }
    
    let pickerSet = SecrectQuestionMessage().questions
    let fontManager = FontManger()
    
    func showPickerInActionSheet() {
        let message = "\n\n\n\n\n\n\n\n"
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.isModalInPopover = true
        
        let attributedString = NSAttributedString(string: "Secret Question", attributes: [
            NSFontAttributeName :UIFont(name: fontManager.naviTitleFont, size: 18.0)!,
            NSForegroundColorAttributeName : UIColor.black ])
        
        alert.setValue(attributedString, forKey: "attributedTitle")
        
        let pickerFrame:CGRect = CGRect(x: 0, y: 52, width: 270, height: 140)
        let picker: UIPickerView = UIPickerView(frame: pickerFrame)
        picker.backgroundColor = .clear
        
        picker.delegate = self
        picker.dataSource = self
        
        alert.view.addSubview(picker)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alert.addAction(cancelAction)
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in self.doSomethingWithValue(value: self.pickerSet[picker.selectedRow(inComponent: 0)]) })
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    
    @available(iOS 2.0, *)
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int { return pickerSet.count }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {}
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? { return pickerSet[row] }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerSet[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [
            NSFontAttributeName : UIFont.systemFont(ofSize: 9),
            NSForegroundColorAttributeName : UIColor.black])
        return myTitle
    }
    
    func doSomethingWithValue(value: String) {
        question.setTitle(value, for: .normal)
        selectQuestion = value
    }
    
    func makeNavigationItem()  {
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let back = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(back, for: .normal)
        backBtn.tintColor = colorManager.tint
        backBtn.addTarget(self, action: #selector(SecretQuestionViewController.back), for: .touchUpInside)
        
        let item = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = item
        
        let saveBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let save = UIImage(named: "lock")?.withRenderingMode(.alwaysTemplate)
        saveBtn.setImage(save, for: .normal)
        saveBtn.tintColor = colorManager.tint
        saveBtn.addTarget(self, action: #selector(SecretQuestionViewController.saveSecretQuestion), for: .touchUpInside)
        
        let item2 = UIBarButtonItem(customView: saveBtn)
        navigationItem.rightBarButtonItem = item2
    }
    
    func back() {
        if keychainManager.haveBeforeSecrectQNA() {
            keychainManager.deleteSecrectQNA()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    private func anwserEmpty() -> Bool {
        if (answer.text?.characters.count)! < 1 {
            showAlert(message: message.empty, haveCancel: false, doneHandler: { (UIAlertAction) in
                self.answer.becomeFirstResponder()
            }, cancelHandler: nil)
            return true
        }
        return false
    }
    
    func saveSecretQuestion() {
        log.info(message: "selectQuestion : \(selectQuestion) , answer : \(answer.text!)")
        if true == anwserEmpty() {
            return;
        }
        else {
            keychainManager.saveSecretQNA(question: selectQuestion, answer: answer.text!)
            showAlert(message: message.success, haveCancel: false, doneHandler: { (UIAlertAction) in
                self.moveToSettingPage()
            }, cancelHandler: nil)
        }
    }
    
    func moveToSettingPage() {
        
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        self.navigationController!.popToViewController((viewControllers[2] as? SettingTableViewController)!, animated: true)
    }
    
    func showAlert(message:String, haveCancel:Bool, doneHandler:((UIAlertAction) -> Swift.Void)?, cancelHandler:((UIAlertAction) -> Swift.Void)?)
    {
        let alertController = UIAlertController(title: "Notice", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: doneHandler))
        if haveCancel {
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: cancelHandler))
        }
        self.present(alertController, animated: true, completion: nil)
    }

    
    /* find mode */
    
    
    func isFindMode() -> Bool {
        if true == SharedMemoryContext.get(key: "findPasswordMode") as? Bool {
            return true
        }
        return false
    }
    
    func showFindButton() {
        if false == isFindMode() {
            ok.alpha = 0.0
            cancel.alpha = 0.0
        }
    }
    
    func showFindNotice() {
        if true == isFindMode() {
            noticeLabel.text = message.findMode
        }
    }
    
    @IBAction func clickOk(_ sender: UIButton) {
        if true == isFindMode() {
            log.info(message: "Q ; \(selectQuestion) A ; \(answer.text)")
            
            if true == anwserEmpty() {
                return;
            }
            // 등록된 질문과 동일한지 찾기
            if true == keychainManager.isRightSecrectQNA(question: selectQuestion, answer: answer.text!) {
                // 새로운 비밀번호 생성해주기 cheesing
                let newPassword = keychainManager.resetPassword()
                showAlert(message: "Your new password is \(newPassword).", haveCancel: false, doneHandler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }, cancelHandler: nil)
            }
            else {
                showAlert(message: message.discord, haveCancel: false, doneHandler: nil, cancelHandler: nil)
            }
        }
    }
    
    @IBAction func clickCancel(_ sender: UIButton) {
        if isFindMode() {
            self.dismiss(animated: true, completion: nil)
        }
    }
    
}
