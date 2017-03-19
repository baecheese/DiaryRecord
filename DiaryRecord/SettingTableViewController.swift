//
//  SettingTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 19..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct SettingMenu {
    let setionList:[String] = ["테스트용", "기본 설정", "iCould", "도움말"]
    let testList:[String] = ["전체 다이어리 정보 로그", "전체 이미지 리스트 로그", "전체 이미지 파일 삭제"]
    let basicList:[String] = ["테마", "비밀번호 설정", "Touch로 잠금"]
    let iCouldList:[String] = ["계정", "로그인 / 로그아웃"]
    let infoList = ["help / 버그 신고", "개발자에게 커피 한 잔 ☕️"]
}

class SettingTableViewController: UITableViewController {

    let log = Logger(logPlace: SettingTableViewController.self)
    let settingMenu = SettingMenu()
    let diaryRepo = DiaryRepository.sharedInstance
    let imageManager = ImageFileManager.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        let menuList = [settingMenu.testList, settingMenu.basicList, settingMenu.iCouldList, settingMenu.infoList]
        return menuList[section].count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return settingMenu.setionList[section]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell", for: indexPath)
        
        let menuList:[[String]] = [settingMenu.testList, settingMenu.basicList, settingMenu.iCouldList, settingMenu.infoList]
        
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
    }
    
    
    /* test용 */
    
    func allDiaryList() {
        log.info(message: "allDiaryList : \(diaryRepo.getAll())")
    }
    
    func allImageList() {
        log.info(message: "allImageList : \(imageManager.getImageFileAllList())")
    }
    
    func deleteAllImageFile() {
        imageManager.deleteAllImageFile()
    }
    
}
