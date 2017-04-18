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

    @IBOutlet var SecretQuestionView: UIView!
    
    
    @IBOutlet var question: UIButton!
    @IBOutlet var answer: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
