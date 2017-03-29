//
//  SettingTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 19..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct SettingMenu {
    let setionList:[String] = ["test", "setting", "icould", "help", "Resorce Licenses"]
    let testList:[String] = ["전체 다이어리 정보 로그", "전체 이미지 리스트 로그", "전체 이미지 파일 삭제"]
    let basicList:[String] = ["테마", "글자 크기", "비밀번호 설정", "Touch로 잠금"]
    let iCouldList:[String] = ["계정", "로그인 / 로그아웃"]
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "setting"
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
        let menuList = [settingMenu.testList, settingMenu.basicList, settingMenu.iCouldList, settingMenu.infoList, settingMenu.licensesInfo]
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
        
        let menuList:[[String]] = [settingMenu.testList, settingMenu.basicList, settingMenu.iCouldList, settingMenu.infoList, settingMenu.licensesInfo]
        cell.textLabel?.font = UIFont(name: fontManger.cellFont, size: fontManger.celltextSize)
        cell.backgroundColor = colorManager.paper
        let menuNameListInSection = menuList[indexPath.section]
        cell.textLabel?.text = menuNameListInSection[indexPath.row]

        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selected = tableView.cellForRow(at: indexPath)
        selected?.setSelected(false, animated: true)
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
        }
        
        if indexPath.section == 1 {
            // 테마 선택
            if indexPath.row == 0 {
                let selectTheme = self.storyboard?.instantiateViewController(withIdentifier: "SelectThemeViewController") as? SelectThemeViewController
                self.navigationController?.pushViewController(selectTheme!, animated: true)
            }
        }
        if indexPath.section == 4 {
            let storyBoard = UIStoryboard(name: "Main", bundle:nil)
            let LicenseVC = storyBoard.instantiateViewController(withIdentifier: "LicenseVC") as UIViewController
            self.navigationController?.pushViewController(LicenseVC, animated: true)
        }
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
        _ = navigationController?.popViewController(animated: true)
    }
    
    
    /* test용 */
    
    func allDiaryList() {
        log.info(message: "allDiaryList : \(diaryRepository.getAll())")
    }
    
    func allImageList() {
        log.info(message: "allImageList : \(imageManager.getImageFileAllList())")
    }
    
    func deleteAllImageFile() {
        imageManager.deleteAllImageFile()
    }
    
}
