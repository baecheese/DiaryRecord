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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let themes = ["basic", "cherry blossoms"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "ThemeCell")
        cell.textLabel?.text = themes[indexPath.row]
        
        let lastTheme = SharedMemoryContext.get(key: "theme") as! Int
        if indexPath.row == lastTheme {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let lastTheme = SharedMemoryContext.get(key: "theme") as! Int
        if (indexPath.row != lastTheme) {
            let oldIndexpath = IndexPath(row: lastTheme, section: 0)
            let oldCell = tableView.cellForRow(at: oldIndexpath)
            oldCell?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        let selected = tableView.cellForRow(at: indexPath)
        selected?.setSelected(false, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
}
