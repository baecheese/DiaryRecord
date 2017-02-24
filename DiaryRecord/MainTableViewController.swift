//
//  MainTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    private let log = Logger(logPlace: MainTableViewController.self)
    
    private let diaryRepository = DiaryRepository()
    
    private var sortedDate = [String]()
    
    var seletedDiaryID = 0
    var saveNewDairy = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 클래스 전역 diarys 쓰면 save 후에 데이터 가져올 때, 저장 전 데이터를 가져온다.
        let diarys = diaryRepository.findDiarys()
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
    }
    
    /**
     개발 테스트 용의 임시 액션 처리
     - parameter sender: no Used
    */
    @IBAction func tempAction(_ sender: Any) {
        // 전체 다이어리 로그 찍기
        log.info(message: "\(diaryRepository.getDiarysAll())")
    }

    /**
     개발 테스트 용의 임시 새로고침
     */
    @IBAction func refreshAction(_ sender: UIBarButtonItem) {
        self.tableView.reloadData()
    }
    
    /*
     (형식 ex)
     [2017.02.12 : [{ts:1486711142.1015279, text:"Frist message"}, {ts:1486711142.1015290, text:"Frist message2"}], 2017.02.11 : [{ts:1486711142.1015279, text:"Frist message"}]]
     */
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let diarys = diaryRepository.findDiarys()
        return diarys.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let diarys = diaryRepository.findDiarys()
        let sortedDate = Array(diarys.keys).sorted(by: >)
        let sectionContentRowCount = (diarys[sortedDate[section]]?.count)!
        return sectionContentRowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diarys = diaryRepository.findDiarys()
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        let targetDate = sortedDate[indexPath.section]
        //같은 날짜 내에 컨텐츠를 최신 순으로 row에 정렬
        cell.textLabel?.text = diarys[targetDate]?[indexPath.row].content
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sortedDate[section]
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let diarys = diaryRepository.findDiarys()
        seletedDiaryID = selectedDairyID(diarys: diarys, section: indexPath.section, row: indexPath.row)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let diarys = diaryRepository.findDiarys()
        seletedDiaryID = selectedDairyID(diarys: diarys, section: indexPath.section, row: indexPath.row)
        
        if editingStyle == .delete
        {
            diaryRepository.deleteDiary(id: seletedDiaryID)
            
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            
            UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                    self.tableView.reloadData()
                    let diarys = self.diaryRepository.findDiarys()
                    // 최신 순 날짜 Array 정렬
                    self.sortedDate = Array(diarys.keys).sorted(by: >)
            }, completion: nil)
        }
    }
    
    private func selectedDairyID(diarys:[String : Array<Diary>], section:Int, row:Int) -> Int {
        let targetDate = sortedDate[section]
        return ((diarys[targetDate]?[row])?.id)!
    }
    
}
