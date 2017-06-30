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

    @IBOutlet var previewScroll: UIScrollView!
    @IBOutlet var tableView: UITableView!
    let log = Logger(logPlace: SelectThemeViewController.self)
    private var cell = UITableViewCell()
    private var lastTheme = ThemeRepositroy.sharedInstance.get()
    private var selectTheme:Int?
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    private let fontManager = FontManager.sharedInstance
    
    var themeImage = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        makeNavigationItem()
        setPreview(theme: lastTheme)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func makeNavigationItem() {
        let updateBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        let update = UIImage(named: "download")?.withRenderingMode(.alwaysTemplate)
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
            getMainTableView().changeTheme = true
        }
        navigationController?.popToViewController(getMainTableView(), animated: true)
    }
    
    func getMainTableView() -> MainTableViewController {
        let viewControllers:[UIViewController] = self.navigationController!.viewControllers as [UIViewController]
        return (viewControllers[1] as? MainTableViewController)!
    }
    
    @objc private func back() {
        log.info(message: "뒤로가기")
        _ = navigationController?.popViewController(animated: true)
    }
    
    let themes = ["basic", "spring", "cherry blossoms", "jos", "ocean" , "snow"]
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return themes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "ThemeCell")
        cell.textLabel?.text = themes[indexPath.row]
        cell.textLabel?.font = UIFont(name: fontManager.cellSubFont, size: fontManager.cellTextSize)
        
        if indexPath.row == lastTheme {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        changePreviewImage(theme: indexPath.row)
        
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
    
    func setPreview(theme:Int) {
        let previewWidth = self.view.frame.width * 0.4 * 3
        let previewHeight = self.view.frame.height * 0.4
        themeImage = UIImageView(frame: CGRect(x: 0, y: 0, width: previewWidth, height: previewHeight))
        themeImage.contentMode = .scaleToFill
        themeImage.backgroundColor = .blue
        themeImage.image = UIImage(named: getThemeImageName(theme: theme))
        previewScroll.backgroundColor = .black
        
        previewScroll.contentOffset = CGPoint.zero
        self.automaticallyAdjustsScrollViewInsets = false

        
        previewScroll.contentSize = themeImage.bounds.size
        previewScroll.addSubview(themeImage)
    }
    
    func getThemeImageName(theme:Int) -> String {
        if theme == 0 {
            return "basic.png"
        }
        if theme == 1 {
            return "spring.png"
        }
        if theme == 2 {
            return "cherryBlossoms.png"
        }
        if theme == 3 {
            return "jos.png"
        }
        if theme == 4 {
            return "ocean.png"
        }
        if theme == 5 {
            return "snow.png"
        }
        return "basic.png"
    }
    
    func changePreviewImage(theme:Int) {
        themeImage.image = UIImage(named: getThemeImageName(theme: theme))
    }
}
