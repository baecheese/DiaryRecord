//
//  MainTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

/** MainTableViewController */

class MainTableViewCell: UITableViewCell {
    @IBOutlet var contentsLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
}

class MainTableViewController: UITableViewController {
    
    private let log = Logger(logPlace: MainTableViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    private let specialDayRepository = SpecialDayRepository.sharedInstance
    private let imageManager = ImageFileManager.sharedInstance
    private var colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let wedgetManager = WedgetManager.sharedInstance
    private var sortedDate = [String]()
    private let fontManager = FontManager.sharedInstance
    var changeTheme = false
    private var beforeSpecialDay:Int? = nil
    
    private let margenX:CGFloat = 30.0
    private let sectionHeghit:CGFloat = 55.0
    private let cellHeghit:CGFloat = 50.0
    
    private var fristLoad = true
    
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
        
        if true == changeTheme {
            viewDidLoad()
            self.tableView.reloadData()
        }
        
        showCellAnimate()

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info(message: "앱이 시작되었습니다.")
        navigationController?.setNavigationBarHidden(false, animated: true)
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
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeghit
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = setHeaderView(section:section)
        return headerView
    }
    
    private func setHeaderView(section:Int) -> UIView {
        let bottomMargen:CGFloat = 5.0
        let labelHight:CGFloat = 20
        let headerLabel = UILabel(frame: CGRect(x: margenX, y: sectionHeghit - labelHight - bottomMargen, width: tableView.bounds.size.width - margenX*2, height: labelHight))
//        headerLabel.backgroundColor = colorManager.date
        headerLabel.backgroundColor = colorManager.paper
        let diarys = diaryRepository.getAllByTheDate()
        // 최신 순 날짜 Array 정렬
        sortedDate = Array(diarys.keys).sorted(by: >)
        let date = sortedDate[section]
        headerLabel.text = "\(date)"
        headerLabel.font = UIFont(name: fontManager.headerFont, size: fontManager.headerTextSize)
        headerLabel.textAlignment = .left
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: sectionHeghit))
        //        headerView.backgroundColor = .blue
//        headerView.backgroundColor = colorManager.date
        headerView.backgroundColor = colorManager.paper
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return cellHeghit
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath) as! MainTableViewCell
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = colorManager.paper
        if true == checkSecretMode() && false == correctPassword() {
            setcheckSecretCell(cell:cell)
            return cell
        }
        
        let cellDiaryID = diaryRepository.getSelectedDiaryID(section: indexPath.section, row: indexPath.row)
        
        // 가장 좋아하는 일기 취소 시
        if wedgetManager.isSpecialDayMode() && cellDiaryID == beforeSpecialDay {
            UIView.transition(with: cell, duration: 0.5, options: .curveEaseOut, animations: {
                cell.backgroundColor = .clear
            }, completion: nil)
        }
        
        cell.backgroundColor = colorManager.paper
        
        let diarys = diaryRepository.getAllByTheDate()
        let targetDate = sortedDate[indexPath.section]

        setContentsCell(cell: cell, diary: (diarys[targetDate]?[indexPath.row])!)
        
        // 위젯 선택모드 + 가장 좋아하는 일기 선택 시
        if  wedgetManager.isSpecialDayMode() && true == specialDayRepository.isRight(id: cellDiaryID) {
            UIView.transition(with: cell, duration: 0.3, options: .curveEaseIn, animations: {
                cell.backgroundColor = self.colorManager.special
                cell.textLabel?.backgroundColor = .clear
            }, completion: nil)
        }
        
        return cell
    }
    
    func setContentsCell(cell:MainTableViewCell, diary:Diary) {
        cell.contentsLabel.text = diary.content
        cell.timeLabel.text = diary.timeStamp.getHHMM()
        
        cell.contentsLabel.text = removeIndent(contents: diary.content)
        cell.contentsLabel.font = UIFont(name: fontManager.cellFont, size: fontManager.cellTextSize)
        cell.contentsLabel.backgroundColor = .clear
        cell.contentsLabel.textColor = colorManager.mainText
        
        cell.timeLabel.backgroundColor = .clear
        cell.timeLabel.textAlignment = .right
        cell.timeLabel.text = diary.timeStamp.getHHMM()
        cell.timeLabel.font = UIFont(name: fontManager.cellSubFont, size: fontManager.cellSubTextSize)
        cell.timeLabel.textColor = colorManager.subText
    }
    
    func setcheckSecretCell(cell:MainTableViewCell) {
        cell.contentsLabel.text = "Secret Mode"
        cell.contentsLabel.textColor = colorManager.subText
        cell.contentsLabel.font = UIFont(name: fontManager.cellFont, size: fontManager.cellTextSize)
        cell.contentsLabel.backgroundColor = .clear
        cell.timeLabel.backgroundColor = .clear
        cell.timeLabel.textColor = .clear
    }
    
    private func removeIndent(contents:String) -> String {
        if " " == contents.characters.first {
            let newContentIndex = contents.index(contents.startIndex, offsetBy: 1)
            return contents.substring(from: newContentIndex)
        }
        return contents
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        SharedMemoryContext.set(key: "selectedDiaryInfo", setValue: (indexPath.section, indexPath.row))
        
        
        let readVC = self.storyboard?.instantiateViewController(withIdentifier: "ReadViewController") as? ReadViewController
        
        UIView.transition(with: self.navigationController!.view, duration: 1.0, options: UIViewAnimationOptions.transitionCurlUp, animations: {
            self.navigationController?.pushViewController(readVC!, animated: false)
        }, completion: {(Bool) in
            let selectedDiaryInfo = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
            let selectedDiaryID = self.diaryRepository.getSelectedDiaryID(section: selectedDiaryInfo.0, row: selectedDiaryInfo.1)
            let diary = self.diaryRepository.findOne(id: selectedDiaryID)!
//            readVC?.showAnimationToolbarItem(message: diary.timeStamp.getAllTimeInfo(), date: diary.timeStamp.getAllTimeInfo())
            readVC?.showAnimationToolbarItem(message: diary.timeStamp.getDateLongStyle(), date: diary.timeStamp.getDateLongStyle())

        })
        
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
        if true == wedgetManager.isSpecialDayMode() {
            let selectedDiaryInfo = SharedMemoryContext.setAndGet(key: "selectedDiaryInfo"
                , setValue: (indexPath.section, indexPath.row)) as! (Int, Int)
            let selectedDiaryID = diaryRepository.getSelectedDiaryID(section: selectedDiaryInfo.0, row: selectedDiaryInfo.1)
            
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
        let selectedDiaryInfo = SharedMemoryContext.setAndGet(key: "selectedDiaryInfo"
            , setValue: (indexPath.section, indexPath.row)) as! (Int, Int)
        let selectedDiaryID = diaryRepository.getSelectedDiaryID(section: selectedDiaryInfo.0, row: selectedDiaryInfo.1)
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
    
    
    
    func navigationFont() {
        navigationItem.title = "index"
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
    
    
    func animateTable() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableHeight: CGFloat = tableView.bounds.size.height
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: 0, y: tableHeight)
        }
        
        var index = 0
        
        for a in cells {
            let cell: UITableViewCell = a as UITableViewCell
            UIView.animate(withDuration: 1.8, delay: 0.2 * Double(index), usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseIn, animations: {
                cell.transform = CGAffineTransform(translationX: 0, y: 0);
            }, completion: nil)
            index += 1
        }
    }

    
    private func showCellAnimate() {
        if true == fristLoad {
            if true == checkSecretMode() {
                if false == correctPassword() {
                    return;
                }
                fristLoad = false
                animateTable()
            }
            else {
                fristLoad = false
                animateTable()
            }
        }
    }
    
    private func checkSecretMode() -> Bool {
        if true == SharedMemoryContext.get(key: "isSecretMode") as? Bool {
            return true
        }
        return false
    }
    
    private func correctPassword() -> Bool {
        if true == SharedMemoryContext.get(key: "correctPassword") as? Bool {
            return true
        }
        return false
    }
    
    
}
