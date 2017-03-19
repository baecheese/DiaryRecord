//
//  MainTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct MainTableState {
    let headerTextSize:CGFloat = 14.0
    let celltextSize:CGFloat = 18.0
    let headerFont:String = "Copperplate-Light"
    let cellFont:String = "NanumMyeongjo"
}

class MainTableViewController: UITableViewController {
    
    private let log = Logger(logPlace: MainTableViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    private let imageManger = ImageFileManager.sharedInstance
    private var sortedDate = [String]()
    private let mainTableState = MainTableState()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // 클래스 전역 diarys 쓰면 save 후에 데이터 가져올 때, 저장 전 데이터를 가져온다.
        let diarys = diaryRepository.findAll()
        // 최신 순 날짜 Array 정렬
        sortedDate = Array(diarys.keys).sorted(by: >)
        DispatchQueue.main.async{
            if true == (SharedMemoryContext.get(key: "saveNewDairy")) as! Bool {
                SharedMemoryContext.changeValue(key: "saveNewDairy", value: false)
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info(message: "앱이 시작되었습니다.")
        navigationController?.navigationBar.barTintColor = UIColor.black
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func moveWritePage(_ sender: UIBarButtonItem) {
        SharedMemoryContext.set(key: "isWriteMode", setValue: true)
        let writeVC = self.storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as? WriteViewController
        self.navigationController?.pushViewController(writeVC!, animated: true)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let diarys = diaryRepository.findAll()
        return diarys.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let diarys = diaryRepository.findAll()
        let sortedDate = Array(diarys.keys).sorted(by: >)
        let sectionContentRowCount = (diarys[sortedDate[section]]?.count)!
        return sectionContentRowCount
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diarys = diaryRepository.findAll()
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.font = UIFont(name: mainTableState.cellFont, size: mainTableState.celltextSize)
        let targetDate = sortedDate[indexPath.section]
        //같은 날짜 내에 컨텐츠를 최신 순으로 row에 정렬
        cell.textLabel?.text = diarys[targetDate]?[indexPath.row].content
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let diarys = diaryRepository.findAll()
        // 최신 순 날짜 Array 정렬
        sortedDate = Array(diarys.keys).sorted(by: >)
        return sortedDate[section]
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.font = UIFont(name: mainTableState.headerFont, size: mainTableState.headerTextSize)
        header.textLabel?.textColor = UIColor.darkGray
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDiaryID = getSelectedDiaryID(section: indexPath.section, row: indexPath.row)
        SharedMemoryContext.set(key: "seletedDiaryID", setValue: selectedDiaryID)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let seletedDiaryID = SharedMemoryContext.setAndGet(key: "seletedDiaryID"
            , setValue: getSelectedDiaryID(section: indexPath.section, row: indexPath.row)) as! Int
        
        if editingStyle == .delete
        {
            diaryRepository.delete(id: seletedDiaryID)
            imageManger.deleteImageFile(diaryID: seletedDiaryID)
            // 삭제 후, 다이어리를 찾았을 때
            let diarys = self.diaryRepository.findAll()
            /* 마지막 Diary 일 때 row를 지우면 NSInternalInconsistencyException이 일어남
             -> 마지막 diary일 땐 그냥 비어있는 diary 데이터로 tableView reload data */
            if false == isLastDairy(diarys: diarys) {
                // 마지막 diary가 아니면 deleteRow를 한다.
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
            UIView.transition(with: self.tableView, duration: 1.0, options: .transitionCrossDissolve, animations: {
                self.sortedDate = Array(diarys.keys).sorted(by: >)
                self.tableView.reloadData()
            }, completion: nil)
        }
    }
    
    func isLastDairy(diarys : [String : Array<Diary>]) -> Bool {
        if 1 < diarys.count {
            return false
        }
        return true
    }
    
    private func getSelectedDiaryID(section:Int, row:Int) -> Int {
        let diarys:[String : Array<Diary>] = diaryRepository.findAll()
        let targetDate = sortedDate[section]
        return ((diarys[targetDate]?[row])?.id)!
    }

}
