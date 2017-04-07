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
    let headerFont:String = "Copperplate-Light"
    let cellFont:String = "NanumMyeongjo"
    
    let naviTitleFontSize:CGFloat = 20.0
    let naviItemFontSize:CGFloat = 15.0
    let naviTitleFont:String = "Copperplate-Light"
}

class MainTableViewController: UITableViewController {
    
    private let log = Logger(logPlace: MainTableViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    private let specialDayRepository = SpecialDayRepository.sharedInstance
    private let imageManager = ImageFileManager.sharedInstance
    private var colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let wedgetManager = WedgetManager.sharedInstance
    private var sortedDate = [String]()
    private let fontManager = FontManger()
    var changeTheme = false
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        tableView.register(MainTableViewCell.self, forCellReuseIdentifier: "cell")
        
        // 클래스 전역 diarys 쓰면 save 후에 데이터 가져올 때, 저장 전 데이터를 가져온다.
        let diarys = diaryRepository.getAllByTheDate()
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
        changeWedget()
        navigationFont()
        changeNavigationTheme()
        view.backgroundColor = colorManager.paper
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
        let diarys = diaryRepository.getAllByTheDate()
        return diarys.keys.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let diarys = diaryRepository.getAllByTheDate()
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
        headerLabel.backgroundColor = colorManager.date
        let diarys = diaryRepository.getAllByTheDate()
        // 최신 순 날짜 Array 정렬
        sortedDate = Array(diarys.keys).sorted(by: >)
        let date = sortedDate[section]
        headerLabel.text = "\(date)"
        headerLabel.font = UIFont(name: fontManager.headerFont, size: fontManager.headerTextSize)
        headerLabel.textAlignment = .right
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = colorManager.date
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 50.0 // 추후 글자 크기에 따라 다르게 적용 되게 -- cheesing
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diarys = diaryRepository.getAllByTheDate()
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont(name: fontManager.cellFont, size: fontManager.celltextSize)
        cell.backgroundColor = colorManager.paper
//        cell.backgroundColor = .clear
        let targetDate = sortedDate[indexPath.section]
        //같은 날짜 내에 컨텐츠를 최신 순으로 row에 정렬
        cell.textLabel?.text = diarys[targetDate]?[indexPath.row].content
        
        let cellDiaryID = getSelectedDiaryID(section: indexPath.section, row: indexPath.row)
        if  wedgetManager.getMode() == 2 && true == specialDayRepository.isRight(id: cellDiaryID) {
            cell.backgroundColor = colorManager.special
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDiaryID = getSelectedDiaryID(section: indexPath.section, row: indexPath.row)
        SharedMemoryContext.set(key: "selectedDiaryID", setValue: selectedDiaryID)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let favorite = UITableViewRowAction(style: .normal, title: "🌟") { action, index in
            self.log.info(message: "🌟 click favorite")
            self.setSpecialDay(indexPath: editActionsForRowAt)
        }
        favorite.backgroundColor = .blue
        
        let delete = UITableViewRowAction(style: .normal, title: "delete") { action, index in
            self.deleteCell(indexPath: editActionsForRowAt)
        }
        delete.backgroundColor = .orange
        
        return [delete, favorite]
    }
    
    private func setSpecialDay(indexPath: IndexPath) {
        if wedgetManager.getMode() == 2 {
            let selectedDiaryID = SharedMemoryContext.setAndGet(key: "selectedDiaryID"
                , setValue: getSelectedDiaryID(section: indexPath.section, row: indexPath.row)) as! Int
            
            /* 이미 스페셜 데이인 것을 한 번 더 누른 건 스페셜 데이 취소 */
            if specialDayRepository.isRight(id: selectedDiaryID) {
                specialDayRepository.delete(id: selectedDiaryID)
                UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.tableView.reloadData()
                }, completion: nil)
                return;
            }
            
            /* 아니면 저장 */
            // (저장결과, 메세지)
            var trySaveDiary:(Bool, String) = (true, "")
            trySaveDiary = specialDayRepository.save(diaryID: selectedDiaryID)
            
            let saveSuccess = trySaveDiary.0
            let saveMethodResultMessage = trySaveDiary.1
            
            if false == saveSuccess {
                showAlert(message: saveMethodResultMessage, haveCancel: false, doneHandler: nil, cancelHandler: nil)
            }
            else {
                // 저장 성공 시
                // 위젯 설정
                wedgetManager.setContentsInWedget(mode: wedgetManager.getMode())
                
                // 테이블 리로드 & 스페셜 데이 색깔 변화
                log.info(message: "스페셜 데이 지정 성공 - \(specialDayRepository.getAll())")
                UIView.transition(with: self.tableView, duration: 0.3, options: .transitionCrossDissolve, animations: {
                    self.tableView.reloadData()
                }, completion: nil)
            }
        }
        else {
            // 사용자 설정 모드 아니면 알림
            showAlert(message: "change wedget mode to 사용자지정", haveCancel: false, doneHandler: nil, cancelHandler: nil)
        }
    }
    
    private func deleteCell(indexPath: IndexPath) {
        let selectedDiaryID = SharedMemoryContext.setAndGet(key: "selectedDiaryID"
            , setValue: getSelectedDiaryID(section: indexPath.section, row: indexPath.row)) as! Int
        
        diaryRepository.delete(id: selectedDiaryID)
        imageManager.deleteImageFile(diaryID: selectedDiaryID)
        // 삭제 후, 다이어리를 찾았을 때
        let diarys = self.diaryRepository.getAllByTheDate()
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
    
    
    func isLastDairy(diarys : [String : Array<Diary>]) -> Bool {
        if 1 < diarys.count {
            return false
        }
        return true
    }
    
    private func getSelectedDiaryID(section:Int, row:Int) -> Int {
        let diarys:[String : Array<Diary>] = diaryRepository.getAllByTheDate()
        let targetDate = sortedDate[section]
        return ((diarys[targetDate]?[row])?.id)!
    }
    
    func navigationFont() {
        navigationItem.title = "diary"
        // Navigation Font
        navigationController?.navigationBar.titleTextAttributes = [ NSFontAttributeName: UIFont(name: fontManager.naviTitleFont, size: fontManager.naviTitleFontSize)!]
    }
    
    func changeNavigationTheme() {
        colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
        navigationController?.navigationBar.barTintColor = colorManager.bar
        navigationController?.navigationBar.tintColor = colorManager.tint
        changeTheme = false
    }
    
    func changeWedget() {
        let nowWedgetMode = wedgetManager.getMode()
        if 2 != nowWedgetMode && TimeInterval().passADay() {
            wedgetManager.setContentsInWedget(mode: wedgetManager.getMode())
            log.info(message: "pass a day and changeWedget")
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
    
    
    
}
