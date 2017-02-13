//
//  MainTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    let log = Logger.init(logPlace: MainTableViewController.self)
    let diarys = DiaryRepository().findDiarys()
    var sortedDate = [String]()
    
    var seletedDiary = Diary()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // 최신 순 날짜 Array 정렬
        sortedDate = Array(diarys.keys).sorted(by: >)
        
        self.tableView.reloadData()
    }
    
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
        // 전체보기
        log.info(message: "\(DiaryRepository().getDiarysAll())")
    }

    @IBAction func deleteAction(_ sender: UIBarButtonItem) {
        // 테스트 버튼
    }
    // ------------------------------------------//
    
    
    // MARK: - Table view data source
    
    
    /*
     (형식 ex)
     [2017.02.12 : [{ts:1486711142.1015279, text:"Frist message"}, {ts:1486711142.1015290, text:"Frist message2"}], 2017.02.11 : [{ts:1486711142.1015279, text:"Frist message"}]]
     */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return diarys.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sortedDate = Array(diarys.keys).sorted(by: >)
        let sectionContentRowCount = (diarys[sortedDate[section]]?.count)!
        return sectionContentRowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let section = indexPath.section
        let key = sortedDate[section]//날짜
        cell.textLabel?.text = diarys[key]?[indexPath.row].content//같은 날짜 내에 최신 content
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDate[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let date = sortedDate[indexPath.section]
        seletedDiary = (diarys[date]?[indexPath.row])!
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "Read") {
            let readVC:ReadViewController = segue.destination as! ReadViewController
            readVC.diary = seletedDiary
//
        }
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
