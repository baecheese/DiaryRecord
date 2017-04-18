//
//  EnterPasswordViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 17..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class EnterPasswordViewController: UIViewController, UITextFieldDelegate {

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
    
    private func setDontKnowPasswordImage() {
        one.image = UIImage(named: "dontKnow")
        two.image = UIImage(named: "dontKnow")
        three.image = UIImage(named: "dontKnow")
        four.image = UIImage(named: "dontKnow")
    }
    
    @IBAction func moveFindPasswordPage(_ sender: UIButton) {
        SharedMemoryContext.set(key: "findPasswordMode", setValue: true)
        let SecretQuestionVC = self.storyboard?.instantiateViewController(withIdentifier: "SecretQuestionVC") as? SecretQuestionViewController
        self.navigationController?.pushViewController(SecretQuestionVC!, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
