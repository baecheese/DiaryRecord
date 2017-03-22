//
//  MainTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct FontManger {
    let headerTextSize:CGFloat = 14.0
    let celltextSize:CGFloat = 18.0
    let naviTitleFont:String = "Copperplate-Light"
    let headerFont:String = "Copperplate-Light"
    let cellFont:String = "NanumMyeongjo"
}

class MainTableViewController: UITableViewController {
    
    private let log = Logger(logPlace: MainTableViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    private let imageManager = ImageFileManager.sharedInstance
    private var colorManger = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private var sortedDate = [String]()
    private let fontManager = FontManger()
    var changeTheme = false
    
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
        
        if changeTheme == true {
            viewDidLoad()
            self.tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info(message: "앱이 시작되었습니다.")
        navigationFont()
        changeNavigationTheme()
        view.backgroundColor = colorManger.paper
        self.tableView.separatorStyle = .none
        
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
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // section title 생성을 위한 빈 메소드
        return "date text"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 5, width: tableView.bounds.size.width - 10, height: 20))// y:5 = 위에 마진 / width : -10 = date 오른쪽 마진
        headerLabel.backgroundColor = colorManger.date
        let diarys = diaryRepository.findAll()
        // 최신 순 날짜 Array 정렬
        sortedDate = Array(diarys.keys).sorted(by: >)
        let date = sortedDate[section]
        headerLabel.text = "\(date)"
        headerLabel.font = UIFont(name: fontManager.headerFont, size: fontManager.headerTextSize)
        headerLabel.textAlignment = .right
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = colorManger.date
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diarys = diaryRepository.findAll()
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        cell.textLabel?.font = UIFont(name: fontManager.cellFont, size: fontManager.celltextSize)
        cell.backgroundColor = colorManger.paper
        let targetDate = sortedDate[indexPath.section]
        //같은 날짜 내에 컨텐츠를 최신 순으로 row에 정렬
        cell.textLabel?.text = diarys[targetDate]?[indexPath.row].content
        
        return cell
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
            imageManager.deleteImageFile(diaryID: seletedDiaryID)
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
    
    func navigationFont() {
        navigationItem.title = "diary"
        // Navigation Font
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: fontManager.naviTitleFont, size: 20)!]
    }
    
    func changeNavigationTheme() {
        colorManger = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
        navigationController?.navigationBar.barTintColor = colorManger.bar
        navigationController?.navigationBar.tintColor = colorManger.tint
        changeTheme = false
    }

}
