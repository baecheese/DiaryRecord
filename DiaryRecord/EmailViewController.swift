//
//  EmailViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 17..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class EmailViewController: UIViewController {

    @IBOutlet var emailField: UITextField!
    private let log = Logger(logPlace: EmailViewController.self)
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let emailManager = EmailManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationItem()
    }

    func makeNavigationItem()  {
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let back = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(back, for: .normal)
        backBtn.tintColor = colorManager.tint
        backBtn.addTarget(self, action: #selector(EmailViewController.back), for: .touchUpInside)
        
        let item = UIBarButtonItem(customView: backBtn)
        navigationItem.leftBarButtonItem = item
        
        let saveBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let save = UIImage(named: "lock")?.withRenderingMode(.alwaysTemplate)
        saveBtn.setImage(save, for: .normal)
        saveBtn.tintColor = colorManager.tint
        saveBtn.addTarget(self, action: #selector(EmailViewController.saveEmail), for: .touchUpInside)
        
        let item2 = UIBarButtonItem(customView: saveBtn)
        navigationItem.rightBarButtonItem = item2
    }
    
    func back() {
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func saveEmail() {
        let email = emailField.text
        if emailManager.isValidEmail(email: email!) {
            emailManager.set(email: email!)
            showAlert(message: "이메일 저장 완료", haveCancel: false, doneHandler: { (UIAlertAction) in
                let viewControllers:[UIViewController] = self.navigationController!.viewControllers as [UIViewController]
                self.navigationController!.popToViewController(viewControllers[viewControllers.count - (viewControllers.count - 1)], animated: true);
            }, cancelHandler: nil)
        }
        else {
            showAlert(message: "유효하지 않은 이메일 입니다.", haveCancel: false, doneHandler: nil, cancelHandler: nil)
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
