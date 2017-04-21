//
//  MainTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** MainTableViewController */
struct FontManger {
    let headerTextSize:CGFloat = 14.0
    let celltextSize:CGFloat = 18.0
    let headerFont:String = "SeoulHangangM"
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
    private var beforeSpecialDay:Int? = nil
    
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
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        useSecretMode()
        changeWedget()
        navigationFont()
        changeNavigationTheme()
        view.backgroundColor = colorManager.paper
        self.tableView.separatorStyle = .none
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func moveSettingPage(_ sender: UIBarButtonItem) {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
            let settingVC = self.storyboard?.instantiateViewController(withIdentifier: "SettingTableViewController") as? SettingTableViewController
            self.navigationController?.pushViewController(settingVC!, animated: false)
        })
    }
    
    @IBAction func moveWritePage(_ sender: UIBarButtonItem) {
        let transition = CATransition()
        transition.duration = 0.6
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        
        SharedMemoryContext.set(key: "isWriteMode", setValue: true)
        let writeVC = self.storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as? WriteViewController
        self.navigationController?.pushViewController(writeVC!, animated: false)
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
        return 50.0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let diarys = diaryRepository.getAllByTheDate()
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        cell.selectionStyle = .none
        
        let cellDiaryID = getSelectedDiaryID(section: indexPath.section, row: indexPath.row)
        
        // 가장 좋아하는 일기 취소 시
        if wedgetManager.getMode() == 2 && cellDiaryID == beforeSpecialDay {
            UIView.transition(with: cell, duration: 0.5, options: .curveEaseOut, animations: {
                cell.backgroundColor = .clear
            }, completion: nil)
        }
        
        cell.textLabel?.font = UIFont(name: fontManager.cellFont, size: fontManager.celltextSize)
        
        //        cell.backgroundColor = colorManager.paper
        cell.backgroundColor = .clear
        let targetDate = sortedDate[indexPath.section]
        //같은 날짜 내에 컨텐츠를 최신 순으로 row에 정렬
        cell.textLabel?.text = diarys[targetDate]?[indexPath.row].content
        
        
        // 위젯 선택모드 + 가장 좋아하는 일기 선택 시
        if  wedgetManager.getMode() == 2 && true == specialDayRepository.isRight(id: cellDiaryID) {
            UIView.transition(with: cell, duration: 0.3, options: .curveEaseIn, animations: {
                cell.backgroundColor = self.colorManager.special
                cell.textLabel?.backgroundColor = .clear
            }, completion: nil)
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedDiaryID = getSelectedDiaryID(section: indexPath.section, row: indexPath.row)
        SharedMemoryContext.set(key: "selectedDiaryID", setValue: selectedDiaryID)
        
        UIView.transition(with: self.navigationController!.view, duration: 1.0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
            let readVC = self.storyboard?.instantiateViewController(withIdentifier: "ReadViewController") as? ReadViewController
            self.navigationController?.pushViewController(readVC!, animated: false)
        }, completion: nil)
        
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        return true
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]? {
        let favorite = UITableViewRowAction(style: .normal, title: "⭐️") { action, index in
            self.setSpecialDay(indexPath: editActionsForRowAt)
        }
        favorite.backgroundColor = .gray
        
        let delete = UITableViewRowAction(style: .normal, title: "delete") { action, index in
            self.deleteCell(indexPath: editActionsForRowAt)
        }
        delete.backgroundColor = .red
        
        return [delete, favorite]
    }
    
    private func setSpecialDay(indexPath: IndexPath) {
        if wedgetManager.getMode() == 2 {
            let selectedDiaryID = SharedMemoryContext.setAndGet(key: "selectedDiaryID"
                , setValue: getSelectedDiaryID(section: indexPath.section, row: indexPath.row)) as! Int
            
            /* 이미 스페셜 데이인 것을 한 번 더 누른 건 스페셜 데이 취소 */
            if specialDayRepository.isRight(id: selectedDiaryID) {
                specialDayRepository.delete(id: selectedDiaryID)
                beforeSpecialDay = wedgetManager.getNowWedgetID()
                self.tableView.reloadData()
                wedgetManager.setContentsInWedget(mode: wedgetManager.getMode())
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
                self.tableView.reloadData()
            }
        }
        else {
            // 사용자 설정 모드 아니면 알림
            showAlert(message: "change wedget mode '사용자지정'", haveCancel: true, doneHandler:
                { (UIAlertAction) in
                    self.moveSelectWedgetPage()
                }, cancelHandler: nil)
        }
    }
    
    private func moveSelectWedgetPage() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromLeft, for: self.navigationController!.view, cache: false)
            let selectWedgetVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectWedgetTableViewController") as? SelectWedgetTableViewController
            self.navigationController?.pushViewController(selectWedgetVC!, animated: false)
        })
    }
    
    private func deleteCell(indexPath: IndexPath) {
        let selectedDiaryID = SharedMemoryContext.setAndGet(key: "selectedDiaryID"
            , setValue: getSelectedDiaryID(section: indexPath.section, row: indexPath.row)) as! Int
        
        diaryRepository.delete(id: selectedDiaryID)
        imageManager.deleteImageFile(diaryID: selectedDiaryID)
        
        if specialDayRepository.isRight(id: selectedDiaryID) {
            specialDayRepository.delete(id: selectedDiaryID)
        }
        
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
            self.wedgetManager.setContentsInWedget(mode: self.wedgetManager.getMode())
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
        navigationItem.title = "diary of contents"
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
    
    func useSecretMode() {
        if true == SharedMemoryContext.get(key: "isSecretMode") as? Bool {
            let EnterPasswordVC = self.storyboard?.instantiateViewController(withIdentifier: "EnterPasswordVC") as? EnterPasswordViewController
            self.modalTransitionStyle = UIModalTransitionStyle.flipHorizontal
            self.modalPresentationStyle = .currentContext
            self.present(EnterPasswordVC!, animated: true, completion: nil)
        }
    }
    
}
