//
//  SelectThemeViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 22..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

// tableView delegate, datasource - stroyboard
class SelectThemeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    let log = Logger(logPlace: SelectThemeViewController.self)
    private var cell = UITableViewCell()
    private var lastTheme = ThemeRepositroy.sharedInstance.get()
    private var selectTheme:Int?
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        makeNavigationItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeNavigationItem() {
        let updateBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let update = UIImage(named: "update")?.withRenderingMode(.alwaysTemplate)
        updateBtn.setImage(update, for: .normal)
        updateBtn.tintColor = colorManager.tint
        updateBtn.addTarget(self, action: #selector(SelectThemeViewController.save), for: .touchUpInside)
        let item = UIBarButtonItem(customView: updateBtn)
        navigationItem.rightBarButtonItem = item
        item.tintColor = colorManager.tint
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let back = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(back, for: .normal)
        backBtn.tintColor = colorManager.tint
        backBtn.addTarget(self, action: #selector(SelectThemeViewController.back), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: backBtn)
        
        navigationItem.leftBarButtonItem = item2
        
    }
    
    @objc private func save() {
        log.info(message: "테마 저장")
        if lastTheme != selectTheme && selectTheme != nil {
            let themeRepository = ThemeRepositroy.sharedInstance
            themeRepository.set(number: selectTheme!)
            let main:MainTableViewController = navigationController?.viewControllers.first as! MainTableViewController
            main.changeTheme = true
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func back() {
        log.info(message: "뒤로가기")
        _ = navigationController?.popViewController(animated: true)
    }
    
    let themes = ["basic", "cherry blossoms"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "ThemeCell")
        cell.textLabel?.text = themes[indexPath.row]
        
        if indexPath.row == lastTheme {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != lastTheme) {
            // 처음 선택됬던 최근 테마가 다른 걸 체크하면 풀리도록
            let oldIndexpath = IndexPath(row: lastTheme, section: 0)
            let oldCell = tableView.cellForRow(at: oldIndexpath)
            oldCell?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        
        selectTheme = indexPath.row
        
        let selected = tableView.cellForRow(at: indexPath)
        selected?.setSelected(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
}
