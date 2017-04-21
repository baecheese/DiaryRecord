//
//  LaunchViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 21..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController, CAAnimationDelegate {

    
    let background = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        background.frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        background.backgroundColor = .red
        view.addSubview(background)
        
        showLaunchAnimation()
    }
    
    
    func showLaunchAnimation() {
        UIView.transition(with: view, duration: 3.0, options: .curveEaseInOut, animations: {
            self.background.backgroundColor = .blue
        }, completion: { (Bool) in
            self.moveToMain()
        })
    }
    
    func fadeInAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
    }

    func moveToMain() {
        UIView.transition(with: self.navigationController!.view, duration: 1.0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
            
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
