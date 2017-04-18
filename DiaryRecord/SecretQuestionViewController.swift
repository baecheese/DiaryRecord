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
}

class SecretQuestionViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    private let log = Logger(logPlace: SecretQuestionViewController.self)
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let selectQuestion = "가장 기억에 남는 장소는?"
    private let keychainManager = KeychainManager.sharedInstance
    
    @IBOutlet var SecretQuestionView: UIView!
    @IBOutlet var question: UIButton!
    @IBOutlet var answer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationItem()
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
    
    func saveSecretQuestion() {
        if answer.text != nil {
            showAlert(message: <#T##String#>, haveCancel: <#T##Bool#>, doneHandler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>, cancelHandler: <#T##((UIAlertAction) -> Void)?##((UIAlertAction) -> Void)?##(UIAlertAction) -> Void#>)
            keychainManager.saveSecretQNA(question: selectQuestion, answer: answer.text!)
            log.info(message: "selectQuestion : \(selectQuestion) , answer : \(answer.text!)")
        }
        else {
            log.info(message: "글자가 없음")
        }
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

/*
 
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
