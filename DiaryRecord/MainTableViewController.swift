//
//  MainTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct Data {
    
    var textArray = ["눈이 몹시 내렸다. 눈은 하늘 높은 곳에서 지상으로 곤두박질쳤다."
        , "그러나 나는 그처럼 쓸쓸한 밤눈들이 언젠가는 지상에 내려앉을 것임을 안다. 그때까지 어떠한 죽음도 눈에게 접근하지 못할 것이다."]
    
    
}

class MainTableViewController: UITableViewController {
    
    let log = Logger.init(logPlace: MainTableViewController.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        log.info(message: "앱이 시작되었습니다.")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // ----- 테스트용 임시 저장 목록 보기 / 데이터 삭제 버튼 ------//
    @IBAction func tempAction(_ sender: Any) {
        log.info(message: "\(DiaryRepository().getDiarysAll())")
    }

    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        
        // 날짜 생성 테스트 버튼
        
        log.info(message: "\(DiaryRepository().getSortedDateList())")
        
//        log.info(message: "timeIntervalSince1970 : \(NSDate().timeIntervalSince1970) --- \(NSDate(timeIntervalSince1970: NSDate().timeIntervalSince1970))")
        //DiaryRepository().deleteDiary(index: 1)
    }
    // ------------------------------------------//
    
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return DiaryRepository().getSortedDateList().count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.text = Data.init().textArray[indexPath.row]
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "section \(section)"
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
