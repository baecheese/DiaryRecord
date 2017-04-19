//
//  EnterPasswordViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 17..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct messageEnterPassword {
    let wrong = "Wrong Password entered!"
}

class EnterPasswordViewController: UIViewController, UITextFieldDelegate {

    private let log = Logger(logPlace: EnterPasswordViewController.self)
    private let keychainManager = KeychainManager.sharedInstance
    private let meassage = messageEnterPassword()
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var one: UIImageView!
    @IBOutlet var two: UIImageView!
    @IBOutlet var three: UIImageView!
    @IBOutlet var four: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldStatus()
        setDontKnowPasswordImage()
    }
    
    private func setTextFieldStatus() {
        passwordField.delegate = self
        passwordField.becomeFirstResponder()
        passwordField.keyboardType = UIKeyboardType.numberPad
        
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 4
        guard let text = textField.text else { return true }
        let newLength = text.characters.count + string.characters.count - range.length
        let newText = text + string
        changeImage(textLength: newLength)
        
        if maxLength == newLength {
            textField.endEditing(true)
            confirmPassword(password: newText)
        }
        
        return true
    }
    
    private func confirmPassword(password:String) {
        if false == keychainManager.isRightPassword(password: password) {
            wrongPssword()
        }
        else {
            dismiss(animated: true, completion: nil)
        }
    }
    
    private func wrongPssword() {
        showAlert(message: meassage.wrong, haveCancel: false, doneHandler: { (UIAlertAction) in
            self.resetPage()
        }, cancelHandler: nil)
    }
    
    private func resetPage() {
        passwordField.text = nil
        setDontKnowPasswordImage()
        passwordField.becomeFirstResponder()
    }
    
    private func setDontKnowPasswordImage() {
        one.image = UIImage(named: "dontKnow")
        two.image = UIImage(named: "dontKnow")
        three.image = UIImage(named: "dontKnow")
        four.image = UIImage(named: "dontKnow")
    }
    
    func changeImage(textLength:Int) {
        if 0 == textLength {
            one.image = UIImage(named: "dontKnow")
            two.image = UIImage(named: "dontKnow")
            three.image = UIImage(named: "dontKnow")
            four.image = UIImage(named: "dontKnow")
        }
        if 1 == textLength {
            one.image = UIImage(named: "know")
            two.image = UIImage(named: "dontKnow")
            three.image = UIImage(named: "dontKnow")
            four.image = UIImage(named: "dontKnow")
        }
        if 2 == textLength {
            one.image = UIImage(named: "know")
            two.image = UIImage(named: "know")
            three.image = UIImage(named: "dontKnow")
            four.image = UIImage(named: "dontKnow")
        }
        if 3 == textLength {
            one.image = UIImage(named: "know")
            two.image = UIImage(named: "know")
            three.image = UIImage(named: "know")
            four.image = UIImage(named: "dontKnow")
        }
        if 4 == textLength {
            one.image = UIImage(named: "know")
            two.image = UIImage(named: "know")
            three.image = UIImage(named: "know")
            four.image = UIImage(named: "know")
        }
    }
    
    @IBAction func moveFindPasswordPage(_ sender: UIButton) {
        SharedMemoryContext.set(key: "findPasswordMode", setValue: true)
        let secretQuestionVC = self.storyboard?.instantiateViewController(withIdentifier: "SecretQuestionVC") as? SecretQuestionViewController
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.modalPresentationStyle = .currentContext // Display on top of current UIView
        self.present(secretQuestionVC!, animated: true, completion: nil)
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
