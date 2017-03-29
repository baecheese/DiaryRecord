//
//  SelectWedgetTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 29..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class SelectWedgetTableViewController: UITableViewController {

    let log = Logger(logPlace: SelectThemeViewController.self)
    private var cell = UITableViewCell()
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let wedgetModeList = WedgetMode().list
    private let lastWedgetMode = WedgetManager.sharedInstance.getMode()
    private var selectedWedgetMode:Int?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationItem()
    }
    
    
    func makeNavigationItem() {
        let updateBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        let update = UIImage(named: "update")?.withRenderingMode(.alwaysTemplate)
        updateBtn.setImage(update, for: .normal)
        updateBtn.tintColor = colorManager.tint
        updateBtn.addTarget(self, action: #selector(SelectWedgetTableViewController.save), for: .touchUpInside)
        let item = UIBarButtonItem(customView: updateBtn)
        navigationItem.rightBarButtonItem = item
        item.tintColor = colorManager.tint
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let back = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(back, for: .normal)
        backBtn.tintColor = colorManager.tint
        backBtn.addTarget(self, action: #selector(SelectWedgetTableViewController.back), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: backBtn)
        
        navigationItem.leftBarButtonItem = item2
        
    }
    
    @objc private func save() {
        let wedgetManager = WedgetManager.sharedInstance
        if lastWedgetMode != selectedWedgetMode && selectedWedgetMode != nil {
            wedgetManager.setMode(number: selectedWedgetMode!)
            log.info(message: "new wedgetMode \(wedgetManager.getMode())")
            // 위젯 바뀌는 코드 넣기
        }
        navigationController?.popToRootViewController(animated: true)
    }
    
    @objc private func back() {
        _ = navigationController?.popViewController(animated: true)
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    let wedgetMode = ["wedget mode"]
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return wedgetMode.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return wedgetModeList.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectWedget", for: indexPath)
        cell.textLabel?.text = wedgetModeList[indexPath.row]
        
        if indexPath.row == lastWedgetMode {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != lastWedgetMode) {
            // 처음 선택됬던 최근 테마가 다른 걸 체크하면 풀리도록
            let oldIndexpath = IndexPath(row: lastWedgetMode, section: 0)
            let oldCell = tableView.cellForRow(at: oldIndexpath)
            oldCell?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        selectedWedgetMode = indexPath.row
        let selected = tableView.cellForRow(at: indexPath)
        selected?.setSelected(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
    
}
