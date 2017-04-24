//
//  LaunchViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 21..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, CAAnimationDelegate {

    private let log = Logger(logPlace: LaunchViewController.self)
    private var colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    
    @IBOutlet var launchTitle: UILabel!
    @IBOutlet var launchSubTitle: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setColor()
        openCover()
    }
    
    func setColor() {
        view.backgroundColor = colorManager.cover
        launchTitle.textColor = colorManager.tint
        launchSubTitle.textColor = colorManager.tint
    }
    
    func openCover() {
        launchTitle.alpha = 0.0
        launchSubTitle.alpha = 0.0
        
        UIView.transition(with: view, duration: 3.0, options: .curveEaseInOut, animations: {
            self.launchTitle.alpha = 1.0
            self.launchSubTitle.alpha = 1.0
        }, completion: { (Bool) in
            self.moveToMain()
        })
    }

    func moveToMain() {
        UIView.transition(with: self.navigationController!.view, duration: 1.0, options: .transitionCurlUp, animations: {
            let main = self.storyboard?.instantiateViewController(withIdentifier: "Main") as? MainTableViewController
            self.navigationController?.pushViewController(main!, animated: false)
        }, completion: nil)
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
