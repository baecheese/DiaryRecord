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
    let defaultMessage = " "
    let movePrevousMessage = "moving prevous page.."
    let moveAfterMessage = "moving after page.."
    let dontMovePrevousMessage = "It's frist dairy!"
    let dontMoveAfterMessage = "It's last dairy!"
}

class ReadViewController: UIViewController {
    
    private let log = Logger.init(logPlace: ReadViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    private let imageManager = ImageFileManager.sharedInstance
    private let fontManager = FontManager.sharedInstance
    @IBOutlet var backgroundView: UIView!
    var card = CardView()
    var readState = ReadState()
    @IBOutlet var readToolbar: UIToolbar!
    
    var prevousBtn = UIButton()
    var messageBtn = UIButton()
    var afterBtn = UIButton()
    
    var cover = UIView()
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
        makeNavigationItem()
        setToolbar(date: getSelectedDairy().timeStamp.getAllTimeInfo())
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
    
    func setToolbar(date:String) {
        
        makeButtonOnToolbar(message: date)
        
        readToolbar.barStyle = UIBarStyle.default
        readToolbar.isTranslucent = true
        readToolbar.clipsToBounds = true
        readToolbar.barTintColor = colorManager.toolbarBarTint
 
        var items = [UIBarButtonItem]()
        items.append(
            UIBarButtonItem(customView: prevousBtn)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        )
        items.append(
            UIBarButtonItem(customView: messageBtn)
        )
        items.append(
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        )
        items.append(
            UIBarButtonItem(customView: afterBtn)
        )
        readToolbar.setItems(items, animated: true)
    }
    
    func showAnimationToolbarItem(message:String, date:String) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        readToolbar.layer.add(transition, forKey: nil)
        self.setToolBarMessage(message: message)
        
        UIView.transition(with: readToolbar, duration: 1.0, options: .curveEaseOut, animations: {
            self.setTintColorOnToolbar(color: self.colorManager.bar)
        }, completion: {(Bool) in
            UIView.transition(with: self.readToolbar, duration: 1.0, options: .curveEaseIn, animations: {
                self.setTintColorOnToolbar(color: self.colorManager.tint)
            }, completion: { (Bool) in
                self.setToolBarMessage(message: date)
            })
        })
    }
    
    private func setToolBarMessage(message:String) {
        messageBtn.setTitle(message, for: .normal)
    }
    
    private func setTintColorOnToolbar(color:UIColor) {
        messageBtn.tintColor = color
    }
    
    func makeButtonOnToolbar(message:String) {
        prevousBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let beforeImg = UIImage(named: "before_30_new.png")?.withRenderingMode(.alwaysTemplate)
        prevousBtn.setImage(beforeImg, for: .normal)
        prevousBtn.tag = 0
        prevousBtn.tintColor = colorManager.toolbarTint
        prevousBtn.addTarget(self, action: #selector(ReadViewController.moveToDifferentDiary(_:)), for: .touchUpInside)
        
        messageBtn = UIButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.width * 0.5, height: 20))
        messageBtn.setTitle(message, for: .normal)
        messageBtn.setTitleColor(colorManager.toolbarTint, for: .normal)
        messageBtn.titleLabel?.font = UIFont(name: fontManager.toolbarFont, size: fontManager.toolbarFontSize)
        
        afterBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 20))
        let afterImg = UIImage(named: "after_30_new.png")?.withRenderingMode(.alwaysTemplate)
        afterBtn.setImage(afterImg, for: .normal)
        afterBtn.tintColor = colorManager.toolbarTint
        afterBtn.tag = 1
        afterBtn.addTarget(self, action: #selector(ReadViewController.moveToDifferentDiary(_:)), for: .touchUpInside)
    }
    
    func moveToDifferentDiary(_ sender: UIButton) {
        
        let before = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
        
        if sender.tag == 0 {
            log.info(message: "< 이전에 썼던 다이어리")
            if true == previousDiary() {
                movePage(isPrevous: true, message: readState.movePrevousMessage)
            }
            else {
                showAnimationToolbarItem(message: readState.dontMovePrevousMessage, date: getSelectedDairy().timeStamp.getAllTimeInfo())
            }
        }
        if sender.tag == 1 {
            log.info(message: "> 이후에 쓴 다이어리")
            if true == afterDiary() {
                movePage(isPrevous: false, message: readState.moveAfterMessage)
            }
            else {
                showAnimationToolbarItem(message: readState.dontMoveAfterMessage, date: getSelectedDairy().timeStamp.getAllTimeInfo())
            }
        }
        
        let after = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
        
        log.info(message: "before : \(before)   after : \(after)")
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
        
        // 0.0 0.1 0.2 1.0 1.1 1.2
        if row == diaryRepository.getLastDiaryOfSomeDay(dateInfo: section) {
            section += 1
            row = 0
        }
        else {
            row += 1
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
        }
        else {
            row -= 1
        }
        SharedMemoryContext.set(key: "selectedDiaryInfo", setValue: (section, row))
        
        return true
    }
    
    func movePage(isPrevous:Bool, message:String) {
        let diary = self.getSelectedDairy()
        var animation = UIViewAnimationOptions.transitionCurlDown
        if isPrevous == false {
            animation = UIViewAnimationOptions.transitionCurlUp
        }
        showAnimationToolbarItem(message: message, date: diary.timeStamp.getAllTimeInfo())
        UIView.transition(with: self.backgroundView, duration: 1.0, options: animation, animations: {
            SharedMemoryContext.set(key: "moveDiaryInReadPage", setValue: true)
            self.changeContents(newDiary: self.getSelectedDairy())
        }, completion: { (Bool) in
            let transition = CATransition()
            transition.duration = 0.4
            transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.type = kCATransitionFade
            self.navigationController?.view.layer.add(transition, forKey: nil)
            self.card.showChangedDiaryContents(content: diary.content, imageName: diary.imageName)
            SharedMemoryContext.set(key: "moveDiaryInReadPage", setValue: false)
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


