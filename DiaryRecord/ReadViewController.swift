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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getSelectedDairy()
        
        // 추후 테마 넣으면 변수 바꾸기
        showContent(themeNumber: 0)
        settingTapGesture()
    }
    
    
    /* 필요한 data */
    func getSelectedDairy() {
        diary = diaryRepository.findOne(id: SharedMemoryContext.get(key: "seletedDiaryID") as! Int)!
    }
    
    /* contents setting 관련 */
    
    func showContent(themeNumber:Int) {
        if themeNumber == 0 {
            makeContentCard(date: diary.timeStamp.getDateString(), content: diary.content, imageName: diary.imageName)
        }
    }
    
    func makeContentCard(date: String, content:String, imageName:String?) {
        let card = CardView(frame: view.bounds, date: date, content: content, imageName: imageName)
        card.backScrollView.contentOffset = CGPoint.zero
        self.automaticallyAdjustsScrollViewInsets = false
        self.backgroundView.addSubview(card)
        
        // tap을 위한 cover (textview가 수정 불가 모드라 view에 add한 gesture 안먹음)
        cover = UIView(frame: backgroundView.bounds)
        cover.backgroundColor = .black
        //card.addSubview(cover)----cheesing
        
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}


