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
    private var colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let keychainManager = KeychainManager.sharedInstance
    private let meassage = messageEnterPassword()
    
    @IBOutlet var passwordField: UITextField!
    
    @IBOutlet var moon: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTextFieldStatus()
        setDontKnowPasswordImage()
    }
    
    private func setTextFieldStatus() {
        passwordField.delegate = self
        passwordField.alpha = 0.0
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
            UIView.transition(with: moon, duration: 1.0, options: .transitionFlipFromBottom, animations: { 
                self.changeImage(textLength: 4)
            }, completion: { (Bool) in
                self.dismiss(animated: true, completion: nil)
            })
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
        moon.image = UIImage(named: "donKnow_m")
    }
    
    private func changeImage(textLength:Int) {
        
        fadeAnimation(view: moon, duration: 0.5)
        
        if 0 == textLength {
            moon.image = UIImage(named: "donKnow_m")
        }
        if 1 == textLength {
            moon.image = UIImage(named: "donKnow1_m")
        }
        if 2 == textLength {
            moon.image = UIImage(named: "donKnow2_m")
        }
        if 3 == textLength {
            moon.image = UIImage(named: "donKnow3_m")
        }
        if 4 == textLength {
            moon.image = UIImage(named: "know_m")
        }
    }
    
    @IBAction func moveFindPasswordPage(_ sender: UIButton) {
        SharedMemoryContext.set(key: "findPasswordMode", setValue: true)
        let secretQuestionVC = self.storyboard?.instantiateViewController(withIdentifier: "SecretQuestionVC") as? SecretQuestionViewController
        
        self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
        self.modalPresentationStyle = .currentContext // Display on top of current UIView
        self.present(secretQuestionVC!, animated: true, completion: nil)
        
    }
    
    private func fadeAnimation(view:UIView, duration: CFTimeInterval) {
        let transition = CATransition()
        transition.duration = duration
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        view.layer.add(transition, forKey: nil)
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
