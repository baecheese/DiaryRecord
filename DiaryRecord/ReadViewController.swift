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
    @IBOutlet var backgroundView: UIView!
    var card = CardView()
    var readState = ReadState()
    @IBOutlet var readToolbar: UIToolbar!
    
    var notice = UILabel()
    
    var cover = UIView()
    var tap = UITapGestureRecognizer()
    
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    
    override func viewWillAppear(_ animated: Bool) {
        if (true == (SharedMemoryContext.get(key: "saveNewDairy")) as? Bool) {
            changeContents(newDiary: getSelectedDairy())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = colorManager.paper
        makeContentCard()
//        settingTapGesture() <-> edite 버튼 생성함
        makeNavigationItem()
        setToolbar()
        makeNoticeLabel()
    }
    
    /* 필요한 data */
    private func getSelectedDairy() -> Diary {
        let selectedDiaryInfo = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
        let selectedDiaryID = diaryRepository.getSelectedDiaryID(section: selectedDiaryInfo.0, row: selectedDiaryInfo.1)
        return diaryRepository.findOne(id: selectedDiaryID)!
    }
    
    /* contents setting 관련 */
    
    func makeContentCard() {
        let diary = getSelectedDairy()
        card.frame = view.bounds
        card.makeReadView(date: diary.timeStamp.getDateLongStyle(), content: diary.content, imageName: diary.imageName)
        card.backScrollView.contentOffset = CGPoint.zero
        self.automaticallyAdjustsScrollViewInsets = false
        self.backgroundView.addSubview(card)
        
        // tap을 위한 cover (textview가 수정 불가 모드라 view에 add한 gesture 안먹음)
//        cover = UIView(frame: card.bounds)
//        cover.backgroundColor = .clear
//        card.addSubview(cover)
//        
    }
    
    func changeContents(newDiary:Diary) {
        if true == SharedMemoryContext.get(key: "moveDiaryInReadPage") as? Bool {
            self.card.changingDiary()
        }
        else {
            self.card.makeReadView(date: newDiary.timeStamp.getDateLongStyle(), content: newDiary.content, imageName: newDiary.imageName)
        }
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
        let fontManager = FontManager.sharedInstance
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
        backBtn.addTarget(self, action: #selector(ReadViewController.goBackIndexPage), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: backBtn)
        
        navigationItem.leftBarButtonItem = item2
    }
    
    func edit() {
        SharedMemoryContext.set(key: "isWriteMode", setValue: false)
        let editVC = self.storyboard?.instantiateViewController(withIdentifier: "WriteViewController") as? WriteViewController
        self.navigationController?.pushViewController(editVC!, animated: true)
    }
    
    func goBackIndexPage() {
        UIView.transition(with: self.navigationController!.view, duration: 0.7, options: UIViewAnimationOptions.transitionCurlDown, animations: {
            let viewControllers:[UIViewController] = self.navigationController!.viewControllers as [UIViewController]
            self.navigationController!.popToViewController(viewControllers[viewControllers.count - (viewControllers.count - 1)], animated: false);
        }, completion: nil)
    }
    
    func setToolbar() {
        readToolbar.barStyle = UIBarStyle.default
        readToolbar.isTranslucent = true
        readToolbar.clipsToBounds = true
        readToolbar.barTintColor = colorManager.paper
        readToolbar.tintColor = colorManager.tint
        showAnimationToolbarItem()
    }
    
    func showAnimationToolbarItem() {
        UIView.transition(with: readToolbar, duration: 5.0, options: .curveEaseInOut, animations: {
            //            self.readToolbar.barTintColor = self.colorManager.bar
            self.readToolbar.tintColor = self.colorManager.bar
        }, completion: {(Bool) in
            UIView.transition(with: self.readToolbar, duration: 3.0, options: .curveEaseInOut, animations: {
                //                self.readToolbar.barTintColor = self.colorManager.paper
                self.readToolbar.tintColor = self.colorManager.tint
            }, completion: nil)
        })
    }
    
    func makeNoticeLabel() {
        notice.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        notice.text = "33"
        notice.backgroundColor = .red
        card.addSubview(notice)
    }
    
    @IBAction func moveToDifferentDiary(_ sender: UIBarButtonItem) {
        log.info(message: "before: \(SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int))")
        if sender.tag == 0 {
            log.info(message: "< 이전에 썼던 다이어리")
            if true == previousDiary() {
                movePage(message: "moving prevous page")
            }
            else {
                showNoticeAnimation(message: "It's frist dairy")
            }
        }
        if sender.tag == 1 {
            log.info(message: "> 이후에 쓴 다이어리")
            if true == afterDiary() {
                movePage(message: "moving after page")
            }
            else {
                showNoticeAnimation(message: "It's last dairy")
            }
        }
        
    }
    
    func showNoticeAnimation(message:String) {
        
    }
    
    func showNoticeLabel(message:String) {
        notice.text = message
        notice.sizeToFit()
        notice.frame.origin = CGPoint(x: self.view.frame.width/2 - notice.frame.width/2, y: self.view.frame.height/2 - notice.frame.height/2)
        notice.backgroundColor = .black
        notice.textColor = .white
        notice.alpha = 0.6
    }
    
    func disappearNoticeLabel() {
        notice.alpha = 0.0
    }
    
    // < 이전에 썼던 다이어리 (테이블 순서로는 아래로, 숫자는 +)
    func previousDiary() -> Bool {
        let selectedDiaryInfo = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
        var section = selectedDiaryInfo.0
        var row = selectedDiaryInfo.1
        if diaryRepository.isFrist(diaryInfo: selectedDiaryInfo) {
            log.info(message: "처음")
            return false
        }
        
        if true == diaryRepository.isLastDiaryOfOneDay(diaryInfo: selectedDiaryInfo) {
            section += 1
            let diarysOfOneDay = diaryRepository.getDiarysOfOneDay(section: section)
            row = diarysOfOneDay.count - 1
            log.info(message: "after : \((section, row))")
        }
        else {
            row += 1
            log.info(message: "after : \((section, row))")
        }
        SharedMemoryContext.set(key: "selectedDiaryInfo", setValue: (section, row))
        
        return true
    }
    
    // > 이후에 쓴 다이어리 (테이블 순서론 위로, 숫자는 - )
    func afterDiary() -> Bool {
        let selectedDiaryInfo = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
        var section = selectedDiaryInfo.0
        var row = selectedDiaryInfo.1
        if diaryRepository.isLast(diaryInfo: selectedDiaryInfo) {
            log.info(message: "끝")
            return false
        }
        
        if row == 0 {
            section -= 1
            let diarysOfOneDay = diaryRepository.getDiarysOfOneDay(section: section)
            row = diarysOfOneDay.count - 1
            log.info(message: "after : \((section, row))")
        }
        else {
            row -= 1
            log.info(message: "after : \((section, row))")
        }
        SharedMemoryContext.set(key: "selectedDiaryInfo", setValue: (section, row))
        
        return true
    }
    
    func movePage(message:String) {
        UIView.transition(with: self.view, duration: 1.0, options: .transitionCurlDown, animations: {
            SharedMemoryContext.set(key: "moveDiaryInReadPage", setValue: true)
            self.changeContents(newDiary: self.getSelectedDairy())
//            self.showNoticeLabel(message: message)
        }, completion: { (Bool) in
            let transition = CATransition()
            transition.duration = 1.0
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            let diary = self.getSelectedDairy()
            self.card.showChangedDiaryContents(content: diary.content, imageName: diary.imageName)
//            self.disappearNoticeLabel()
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


