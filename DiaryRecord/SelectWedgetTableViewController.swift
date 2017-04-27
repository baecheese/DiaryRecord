//
//  SelectWedgetTableViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 3. 29..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct WedgetMessage {
    let protectSecret = "For privacy, You can't use random and past of today for using secret mode"
}

class SelectWedgetTableViewController: UITableViewController {

    let log = Logger(logPlace: SelectThemeViewController.self)
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let wedgetModeList = WedgetMode().list
    private let lastWedgetMode = WedgetManager.sharedInstance.getMode()
    private var selectedWedgetMode:Int?
    private let message = WedgetMessage()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        log.info(message: "lastWedgetMode : \(lastWedgetMode)")
        makeNavigationItem()
    }
    
    
    func makeNavigationItem() {
        let updateBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let update = UIImage(named: "upload")?.withRenderingMode(.alwaysTemplate)
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
    
    func save() {
        let wedgetManager = WedgetManager.sharedInstance
        if lastWedgetMode != selectedWedgetMode && selectedWedgetMode != nil {
            if true == protectSecret() {
                showAlert(message: message.protectSecret, haveCancel: false, doneHandler: nil, cancelHandler: nil)
                return;
            }
            wedgetManager.setMode(number: selectedWedgetMode!)
        }
        
        let main:MainTableViewController = getMainTableView()
        main.tableView.reloadData()
        navigationController?.popToViewController(getMainTableView(), animated: true)
    }
    
    func getMainTableView() -> MainTableViewController {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        return (viewControllers[1] as? MainTableViewController)!
    }

    func back() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func protectSecret() -> Bool {
        // 시크릿모드일 때는 위젯을 사용자 지정만 할 수 있음. (사생활 보호)
        if (true == SharedMemoryContext.get(key: "isSecretMode") as? Bool) && (0 != selectedWedgetMode) {
            return true
        }
        return false
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return wedgetModeList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SelectWedgetCell", for: indexPath)
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
        log.info(message: "selectedWedgetMode : \(String(describing: selectedWedgetMode))")
        let selected = tableView.cellForRow(at: indexPath)
        selected?.setSelected(false, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath as IndexPath)?.accessoryType = .none
    }
    
    private func showAlert(message:String, haveCancel:Bool, doneHandler:((UIAlertAction) -> Swift.Void)?, cancelHandler:((UIAlertAction) -> Swift.Void)?)
    {
        let alertController = UIAlertController(title: "Notice", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: doneHandler))
        if haveCancel {
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: cancelHandler))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    
}
