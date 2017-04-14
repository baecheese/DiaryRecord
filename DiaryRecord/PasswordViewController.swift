//
//  PasswordViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct Message {
    let enterPassword = "Enter a password for this user."
    let enterPasswordAgain = "Enter a password again"
    let matchFail = "The New and Confirm passwords must match."
    let blankFail = "Enter the 4 character password."
}

class PasswordViewController: UIViewController, UITextFieldDelegate {
    
    private let log = Logger(logPlace: PasswordViewController.self)
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let message = Message()
    
    @IBOutlet var guide: UILabel!
    private var password = ""
    private var againPassword = ""
    
    @IBOutlet var frist: UIImageView!
    @IBOutlet var second: UIImageView!
    @IBOutlet var three: UIImageView!
    @IBOutlet var four: UIImageView!

    @IBOutlet var passwordField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guide.text = message.enterPassword
        makeNavigationItem()
        setTextFieldStatus()
        setDontKnowPasswordImage()
    }
    
    func setTextFieldStatus() {
        
        passwordField.delegate = self
        passwordField.becomeFirstResponder()
        passwordField.keyboardType = UIKeyboardType.numberPad
        
    }
    
    private var last = false
    let maxLength = 4
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        var newLength = text.characters.count + string.characters.count - range.length
        let newText = text + string
        
        if maxLength == newLength {
            if false == last {
                password = newText
                self.guide.text = self.message.enterPasswordAgain
                self.setDontKnowPasswordImage()
                return true
            }
            else {
                againPassword = newText
                textField.endEditing(true)
                last = false
            }
        }
        if maxLength < newLength {
            textField.text = ""
            newLength = 1
            last = true
        }
        
        changeImage(textLength: newLength)
        return true
    }
    
    func setDontKnowPasswordImage() {
        frist.image = UIImage(named: "dontKnow")
        second.image = UIImage(named: "dontKnow")
        three.image = UIImage(named: "dontKnow")
        four.image = UIImage(named: "dontKnow")
    }
    
    func changeImage(textLength:Int) {
        if 0 == textLength {
            frist.image = UIImage(named: "dontKnow")
            second.image = UIImage(named: "dontKnow")
            three.image = UIImage(named: "dontKnow")
            four.image = UIImage(named: "dontKnow")
        }
        if 1 == textLength {
            frist.image = UIImage(named: "know")
            second.image = UIImage(named: "dontKnow")
            three.image = UIImage(named: "dontKnow")
            four.image = UIImage(named: "dontKnow")
        }
        if 2 == textLength {
            frist.image = UIImage(named: "know")
            second.image = UIImage(named: "know")
            three.image = UIImage(named: "dontKnow")
            four.image = UIImage(named: "dontKnow")
        }
        if 3 == textLength {
            frist.image = UIImage(named: "know")
            second.image = UIImage(named: "know")
            three.image = UIImage(named: "know")
            four.image = UIImage(named: "dontKnow")
        }
        if 4 == textLength {
            frist.image = UIImage(named: "know")
            second.image = UIImage(named: "know")
            three.image = UIImage(named: "know")
            four.image = UIImage(named: "know")
        }
    }
    
    func makeNavigationItem()  {
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let back = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(back, for: .normal)
        backBtn.tintColor = colorManager.tint
        backBtn.addTarget(self, action: #selector(PasswordViewController.back), for: .touchUpInside)
        
        let item = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = item
        
        let saveBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        saveBtn.setTitle("save", for: .normal)
        saveBtn.tintColor = colorManager.tint
        saveBtn.addTarget(self, action: #selector(PasswordViewController.savePassword), for: .touchUpInside)
        
        let item2 = UIBarButtonItem(customView: saveBtn)
        navigationItem.rightBarButtonItem = item2
    }
    
    func back() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func savePassword() {
        log.info(message: "passWord : \(password) againPassWord : \(againPassword) ")
        
        if password.characters.count < 4 || againPassword.characters.count < 4 {
            resetPassword(message: message.blankFail)
        }
        
        if password == againPassword {
            log.info(message: "password 저장")
        }
        else {
            resetPassword(message: message.matchFail)
        }
    }
    
    func resetPassword(message:String) {
        guide.text = message
        guide.textColor = .red
        password = ""
        againPassword = ""
        passwordField.text = nil
        setDontKnowPasswordImage()
        passwordField.becomeFirstResponder()
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
