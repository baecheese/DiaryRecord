//
//  SettingTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 19..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct SettingMenu {
    let setionList:[String] = ["test", "setting", "help", "Resorce Licenses"]
    let testList:[String] = ["전체 다이어리 정보 로그", "전체 이미지 리스트 로그", "전체 이미지 파일 삭제", "스페셜 데이 전체", "비밀번호"]
    let basicList:[String] = ["Theme", "Widget", "Font size", "Password", "Touch ID"]
    let infoList:[String] = ["help / 버그 신고", "개발자에게 커피 한 잔 ☕️"]
    let licensesInfo:[String] = ["licenses info"]
}

class SettingTableCell: UITableViewCell {
    @IBOutlet var title: UILabel!
}

class SettingTableViewController: UITableViewController {

    let log = Logger(logPlace: SettingTableViewController.self)
    private let settingMenu = SettingMenu()
    private let diaryRepository = DiaryRepository.sharedInstance
    private let imageManager = ImageFileManager.sharedInstance
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let fontManager = FontManager.sharedInstance
    private let swich = UISwitch()
    
    let sectionHeghit:CGFloat = 55.0
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorManager.paper
        navigationItem.title = "setting"
        makeNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return settingMenu.setionList.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let menuList = [settingMenu.testList, settingMenu.basicList, settingMenu.infoList, settingMenu.licensesInfo]
        return menuList[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // section title 생성을 위한 빈 메소드
        return "section"
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return sectionHeghit
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = setHeaderView(section: section)
        return headerView
    }
    
    private func setHeaderView(section:Int) -> UIView {
        let margenX:CGFloat = 30.0
        let bottomMargen:CGFloat = 5.0
        let labelHight:CGFloat = 20
        let headerLabel = UILabel(frame: CGRect(x: margenX, y: sectionHeghit - labelHight - bottomMargen, width: tableView.bounds.size.width - margenX*2, height: labelHight))
//        headerLabel.backgroundColor = colorManager.date
        headerLabel.backgroundColor = colorManager.paper
        headerLabel.text = "\(settingMenu.setionList[section])"
        headerLabel.font = UIFont(name: fontManager.headerFont, size: fontManager.headerTextSize)
        headerLabel.textAlignment = .left
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: sectionHeghit))
        //        headerView.backgroundColor = .blue
//        headerView.backgroundColor = colorManager.date
        headerView.backgroundColor = colorManager.paper
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellHeight:CGFloat = 50.0
        return cellHeight
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath) as! SettingTableCell
        
        let menuList:[[String]] = [settingMenu.testList, settingMenu.basicList, settingMenu.infoList, settingMenu.licensesInfo]
        cell.title.font = UIFont(name: fontManager.cellSubFont, size: fontManager.cellTextSize)
        cell.backgroundColor = colorManager.paper
        let menuNameListInSection = menuList[indexPath.section]
        cell.title.text = menuNameListInSection[indexPath.row]
        cell.accessoryType = .none
        
        // 비밀번호 설정 관련
        if indexPath.section == 1 {
            // 비밀번호 설정
            if indexPath.row == 3 {
                setSwichFromPassword(cell: cell)
            }
            // touch 설정
            if indexPath.row == 4 {
                setSwichFromTouchID(cell: cell)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableView.cellForRow(at: indexPath)
        
        /* test용 로그 */
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                allDiaryList()
            }
            if indexPath.row == 1 {
                allImageList()
            }
            if indexPath.row == 2 {
                deleteAllImageFile()
            }
            if indexPath.row == 3 {
                log.info(message: "\(SpecialDayRepository.sharedInstance.getAll())")
            }
            if indexPath.row == 4{
                log.info(message: "Password: \(String(describing: KeychainManager.sharedInstance.loadPassword()))")
            }
        }
        /* setting - "테마", "위젯 설정", "글자 크기", "비밀번호 설정", "Touch로 잠금" */
        if indexPath.section == 1 {
            // 테마 선택
            if indexPath.row == 0 {
                let selectTheme = self.storyboard?.instantiateViewController(withIdentifier: "SelectThemeViewController") as? SelectThemeViewController
                self.navigationController?.pushViewController(selectTheme!, animated: true)
            }
            // 위젯 설정
            if indexPath.row == 1{
                let wedgetMode = self.storyboard?.instantiateViewController(withIdentifier: "SelectWedgetTableViewController") as! SelectWedgetTableViewController
                self.navigationController?.pushViewController(wedgetMode, animated: true)
            }
            // 폰트 사이즈
            if indexPath.row == 2 {
                let selectFontSizeVC = self.storyboard?.instantiateViewController(withIdentifier: "SelectFontSizeTableViewController")
                self.navigationController?.pushViewController(selectFontSizeVC!, animated: true)
            }
            // 비밀번호 설정
            if indexPath.row == 3 {
                /*test용 - 비번 수정용 */
//                let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
//                self.navigationController?.pushViewController(passwordVC, animated: true)                
                selected?.selectionStyle = .none
                return;
            }
            // 터치 ID
            if indexPath.row == 4 {
                
            }
        }
        // infoList - ["help / 버그 신고", "개발자에게 커피 한 잔 ☕️"]
        if indexPath.section == 2 {
            
        }
        // licenses - ["licenses info"]
        if indexPath.section == 3 {
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let LicenseVC = storyBoard.instantiateViewController(withIdentifier: "LicenseVC") as UIViewController
            self.navigationController?.pushViewController(LicenseVC, animated: true)
        }
        
        selected?.setSelected(false, animated: true)
    }
    
    func setSwichFromPassword(cell:UITableViewCell) {
        let margen:CGFloat = 10.0
        let swichSize = swich.frame.size
        swich.frame.origin = CGPoint(x: cell.frame.size.width - swichSize.width - margen, y: cell.frame.size.height / 2 - swichSize.height / 2)
        swich.tag = 1
        swich.addTarget(self, action: #selector(moveSetPasswordPage), for: UIControlEvents.valueChanged)
        cell.contentView.addSubview(swich)
        if false == SharedMemoryContext.get(key: "isSecretMode") as! Bool {
            swich.isOn = false
        }
        else {
            swich.isOn = true
        }
    }
    
    func moveSetPasswordPage() {
        let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
        if swich.isOn == true {
            self.navigationController?.pushViewController(passwordVC, animated: true)
        }
        else {
            showAlert(message: "Are you sure you want to unlock the secret mode?", haveCancel: true, doneHandler: { (UIAlertAction) in
                SharedMemoryContext.set(key: "deletePasswordMode", setValue: true)
                let transition = CATransition()
                transition.duration = 0.5
                transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                transition.type = kCATransitionFade
                self.navigationController?.view.layer.add(transition, forKey: nil)
                _ = self.navigationController?.pushViewController(passwordVC, animated: false)
            }, cancelHandler: { (UIAlertAction) in
                self.swich.setOn(true, animated: true)
            })
        }
    }
    
    func setSwichFromTouchID(cell:UITableViewCell) {
        //        swich.tag = 2
        //        //key - haveTouchID가 잇어야 할 듯
        //        if false == SharedMemoryContext.get(key: "") as! Bool {//chessing
        //            swich.isOn = false
        //        }
        //        else {
        //            swich.isOn = true
        //        }
        //        cell.contentView.addSubview(swich)
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
    
    func makeNavigationItem()  {
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let back = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(back, for: .normal)
        backBtn.tintColor = colorManager.tint
        backBtn.addTarget(self, action: #selector(SettingTableViewController.back), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: backBtn)
        
        navigationItem.leftBarButtonItem = item2
    }
    
    func back() {
        UIView.animate(withDuration: 0.75, animations: { () -> Void in
            UIView.setAnimationCurve(UIViewAnimationCurve.easeInOut)
            UIView.setAnimationTransition(UIViewAnimationTransition.flipFromRight, for: self.navigationController!.view, cache: false)
            _ = self.navigationController?.popViewController(animated: false)
        })
    }
    
    /* test용 */
    
    func allDiaryList() {
        log.info(message: "allDiaryList : \(diaryRepository.getAllList())")
        
        log.info(message: "allDiaryList : \(diaryRepository.getIdAll())")
    }
    
    func allImageList() {
        log.info(message: "allImageList : \(imageManager.getImageFileAllList())")
    }
    
    func deleteAllImageFile() {
        imageManager.deleteAllImageFile()
    }
    
}
