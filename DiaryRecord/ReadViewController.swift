//
//  ReadViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 2. 13..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit

struct ReadState {
    let margen:CGFloat = 30.0
}

class ReadViewController: UIViewController {
    
    private let log = Logger.init(logPlace: ReadViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    private let imageManager = ImageFileManager.sharedInstance
    var diary = Diary()
    @IBOutlet var backgroundView: UIView!
    var readState = ReadState()
    var cover = UIView()
    var tap = UITapGestureRecognizer()
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getSelectedDairy()
        makeContentCard(date: diary.timeStamp.getDateLongStyle(), content: diary.content, imageName: diary.imageName)
//        settingTapGesture() <-> edite 버튼 생성함
        makeNavigationItem()
    }
    
    
    /* 필요한 data */
    func getSelectedDairy() {
        diary = diaryRepository.findOne(id: SharedMemoryContext.get(key: "selectedDiaryID") as! Int)!
    }
    
    /* contents setting 관련 */
    
    func makeContentCard(date: String, content:String, imageName:String?) {
        let card = CardView(frame: view.bounds, date: date, content: content, imageName: imageName)
        card.backScrollView.contentOffset = CGPoint.zero
        self.automaticallyAdjustsScrollViewInsets = false
        self.backgroundView.addSubview(card)
        
        // tap을 위한 cover (textview가 수정 불가 모드라 view에 add한 gesture 안먹음)
//        cover = UIView(frame: card.bounds)
//        cover.backgroundColor = .clear
//        card.addSubview(cover)
//        
    }
    
    func settingTapGesture() {
        // Double Tap
        tap = UITapGestureRecognizer(target: self, action: #selector(ReadViewController.handleDoubleTap))
        tap.numberOfTapsRequired = 2
        cover.addGestureRecognizer(tap)
    }
    
    func handleDoubleTap() {
        SharedMemoryContext.set(key: "isWriteMode", setValue: false)
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as? WriteViewController
        self.navigationController?.pushViewController(editVC!, animated: true)
    }
    
    func makeNavigationItem() {
        let fontManager = FontManager()
        let editBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        editBtn.setTitle("edit", for: .normal)
        editBtn.titleLabel!.font =  UIFont(name: fontManager.naviTitleFont, size: fontManager.naviItemFontSize)
        editBtn.addTarget(self, action: #selector(ReadViewController.edit), for: .touchUpInside)
        let item = UIBarButtonItem(customView: editBtn)
        navigationItem.rightBarButtonItem = item
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let back = UIImage(named: "down")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(back, for: .normal)
        backBtn.tintColor = colorManager.tint
        backBtn.addTarget(self, action: #selector(ReadViewController.back), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: backBtn)
        
        navigationItem.leftBarButtonItem = item2
    }
    
    func edit() {
        SharedMemoryContext.set(key: "isWriteMode", setValue: false)
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as? WriteViewController
        self.navigationController?.pushViewController(editVC!, animated: true)
    }
    
    func back() {
        UIView.transition(with: self.navigationController!.view, duration: 0.7, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            _ = self.navigationController?.popViewController(animated: false)
        }, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


