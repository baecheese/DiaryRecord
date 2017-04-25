//
//  SelectFontSizeTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 4. 26..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

class FontSizeCell: UITableViewCell {
    @IBOutlet var fontSizeTitle: UILabel!
}

class SelectFontSizeTableViewController: UITableViewController {

    private let log = Logger(logPlace: SelectFontSizeTableViewController.self)
    private let fontManager = FontManager.sharedInstance
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private var lastFontMode = FontManager.sharedInstance.getSizeMode()
    private var selectedFontSizeMode:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        makeNavigationItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source\
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return fontManager.sizeList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FontSizeCell", for: indexPath) as! FontSizeCell
        
        cell.fontSizeTitle.text = fontManager.sizeList[indexPath.row]
        cell.fontSizeTitle.font = UIFont(name: fontManager.cellFont, size: setFontSize(row: indexPath.row))
        
        if indexPath.row == fontManager.getSizeMode() {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    private func setFontSize(row:Int) -> CGFloat {
        return fontManager.getCellSizeToMode(mode:row)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.row != lastFontMode) {
            // 처음 선택됬던 최근 테마가 다른 걸 체크하면 풀리도록
            let oldIndexpath = IndexPath(row: lastFontMode, section: 0)
            let oldCell = tableView.cellForRow(at: oldIndexpath)
            oldCell?.accessoryType = .none
        }
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .checkmark
        selectedFontSizeMode = indexPath.row
        log.info(message: "selectedWedgetMode : \(String(describing: selectedFontSizeMode))")
        let selected = tableView.cellForRow(at: indexPath)
        selected?.setSelected(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
    
    
    func makeNavigationItem() {
        let updateBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let update = UIImage(named: "upload")?.withRenderingMode(.alwaysTemplate)
        updateBtn.setImage(update, for: .normal)
        updateBtn.tintColor = colorManager.tint
        updateBtn.addTarget(self, action: #selector(SelectFontSizeTableViewController.save), for: .touchUpInside)
        let item = UIBarButtonItem(customView: updateBtn)
        navigationItem.rightBarButtonItem = item
        item.tintColor = colorManager.tint
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let back = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(back, for: .normal)
        backBtn.tintColor = colorManager.tint
        backBtn.addTarget(self, action: #selector(SelectFontSizeTableViewController.back), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: backBtn)
        
        navigationItem.leftBarButtonItem = item2
        
    }
    
    func save() {
        if lastFontMode != selectedFontSizeMode && selectedFontSizeMode != nil {
            fontManager.setSizeMode(number: selectedFontSizeMode!)
        }
        
        let main:MainTableViewController = getMainTableView()
        main.tableView.reloadData()
        navigationController?.popToViewController(main, animated: true)
    }
    
    private func getMainTableView() -> MainTableViewController {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        return (viewControllers[1] as? MainTableViewController)!
    }
    
    func back() {
        _ = navigationController?.popViewController(animated: true)
    }

}
