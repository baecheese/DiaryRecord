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
    var sortedDate = [String]()
    var saveNewDairy = false
    
    var seletedDiaryID = 0

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 클래스 전역 diarys 쓰면 save 후에 데이터 가져올 때, 저장 전 데이터를 가져온다.
        let diarys = DiaryRepository().findDiarys()
        // 최신 순 날짜 Array 정렬
        sortedDate = Array(diarys.keys).sorted(by: >)
        DispatchQueue.main.async{
            if true == self.saveNewDairy {
                self.tableView.reloadData()
            }
        }
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
    // ------------------------------------------//

    /* 새로고침 */
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
    
    
    // MARK: - Table view data source
    
    /*
     (형식 ex)
     [2017.02.12 : [{ts:1486711142.1015279, text:"Frist message"}, {ts:1486711142.1015290, text:"Frist message2"}], 2017.02.11 : [{ts:1486711142.1015279, text:"Frist message"}]]
     */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let diarys = DiaryRepository().findDiarys()
        return diarys.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let diarys = DiaryRepository().findDiarys()
        let sortedDate = Array(diarys.keys).sorted(by: >)
        let sectionContentRowCount = (diarys[sortedDate[section]]?.count)!
        return sectionContentRowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diarys = DiaryRepository().findDiarys()
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
        let diarys = DiaryRepository().findDiarys()
        // 선택한 diary id 정보
        let date = sortedDate[indexPath.section]
        seletedDiaryID = ((diarys[date]?[indexPath.row])?.id)!
    }
    
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let diaryRepo = DiaryRepository()
        let diarys = diaryRepo.findDiarys()
        // 선택한 diary id 정보
        let date = sortedDate[indexPath.section]
        seletedDiaryID = ((diarys[date]?[indexPath.row])?.id)!
        
        if editingStyle == .delete
        {
            diaryRepo.deleteDiary(id: seletedDiaryID)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {self.tableView.reloadData()}, completion: nil)
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
