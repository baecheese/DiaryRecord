//
//  SettingTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 19..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct SettingMenu {
    let setionList:[String] = ["test", "setting", "secret mode", "help", "Resorce Licenses"]
    let testList:[String] = ["전체 다이어리 정보 로그", "전체 이미지 리스트 로그", "전체 이미지 파일 삭제", "스페셜 데이 전체", "비밀번호 / 이메일"]
    let basicList:[String] = ["테마", "위젯 설정", "글자 크기", "비밀번호 설정", "Touch로 잠금"]
    let secretModeList:[String] = ["계정", "비밀번호 찾기"]
    let infoList:[String] = ["help / 버그 신고", "개발자에게 커피 한 잔 ☕️"]
    let licensesInfo:[String] = ["licenses info"]
}

class SettingTableViewController: UITableViewController {

    let log = Logger(logPlace: SettingTableViewController.self)
    private let settingMenu = SettingMenu()
    private let diaryRepository = DiaryRepository.sharedInstance
    private let imageManager = ImageFileManager.sharedInstance
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let fontManger = FontManger()
    private let emailManager = EmailManager.sharedInstance
    private let swich = UISwitch()
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        let menuList = [settingMenu.testList, settingMenu.basicList, settingMenu.secretModeList, settingMenu.infoList, settingMenu.licensesInfo]
        return menuList[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        // section title 생성을 위한 빈 메소드
        return "section"
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerLabel = UILabel(frame: CGRect(x: 0, y: 5, width: tableView.bounds.size.width - 10, height: 20))// y:5 = 위에 마진 / width : -10 = date 오른쪽 마진
        headerLabel.backgroundColor = colorManager.date
        headerLabel.text = "\(settingMenu.setionList[section])"
        headerLabel.font = UIFont(name: fontManger.headerFont, size: fontManger.headerTextSize)
        headerLabel.textAlignment = .right
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = colorManager.date
        headerView.addSubview(headerLabel)
        
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        
        let menuList:[[String]] = [settingMenu.testList, settingMenu.basicList, settingMenu.secretModeList, settingMenu.infoList, settingMenu.licensesInfo]
        cell.textLabel?.font = UIFont(name: fontManger.cellFont, size: fontManger.celltextSize)
        cell.backgroundColor = colorManager.paper
        let menuNameListInSection = menuList[indexPath.section]
        cell.textLabel?.text = menuNameListInSection[indexPath.row]
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
        // 계정 설정
        if indexPath.section == 2 {
            // 계정 보기 및 수정
            if indexPath.row == 0 {
                setEmailLabel(cell: cell)
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
                log.info(message: "Password: \(KeychainManager.sharedInstance.loadPassword())")
                log.info(message: "Email : \(EmailManager.sharedInstance.get())")
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
            // 비밀번호 설정
            if indexPath.row == 3 {
                /*test용 - 비번 수정용 */
//                let passwordVC = self.storyboard?.instantiateViewController(withIdentifier: "PasswordViewController") as! PasswordViewController
//                self.navigationController?.pushViewController(passwordVC, animated: true)                
                selected?.selectionStyle = .none
                return;
            }
        }
        // secret mode - ["이메일", "비밀번호 찾기"]
        if indexPath.section == 2 {
            if indexPath.row == 0 {
               moveChangeEmailPage()
            }
            if indexPath.row == 1 {
                resetPassword()
            }
        }
        // infoList - ["help / 버그 신고", "개발자에게 커피 한 잔 ☕️"]
        if indexPath.section == 3 {
            
        }
        // licenses - ["licenses info"]
        if indexPath.section == 4 {
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
    
    func setEmailLabel(cell:UITableViewCell) {
        if nil != emailManager.get() {
            cell.textLabel?.text = emailManager.get()
            cell.accessoryType = .disclosureIndicator
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
    
    func moveChangeEmailPage() {
        let emailVC = self.storyboard?.instantiateViewController(withIdentifier: "EmailVC") as! EmailViewController
        self.navigationController?.pushViewController(emailVC, animated: true)
    }
    
    func resetPassword() {
        let message = Message()
        let keychainManager = KeychainManager.sharedInstance
        if true == SharedMemoryContext.get(key: "isSecretMode") as? Bool {
            showAlert(message: message.resetPassword, haveCancel: true, doneHandler: { (UIAlertAction) in
                self.emailManager.sendNewPassword(newPassword: keychainManager.resetPassword())
            }, cancelHandler: nil)
        }
        else {
            showAlert(message: message.notSecretMode, haveCancel: false, doneHandler: nil, cancelHandler: nil)
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
