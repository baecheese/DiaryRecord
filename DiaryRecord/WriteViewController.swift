//
//  WriteViewController.swift
//  DiaryRecord
//
//  Created by 배지영 on 2017. 1. 31..
//  Copyright © 2017년 baecheese. All rights reserved.
//

import UIKit


private extension Selector {
    static let keyboardWillShow = #selector(WriteViewController.keyboardWillShow(notification:))
}

struct WriteState {
    var keyboardHeight:CGFloat = 0.0
    let margen:CGFloat = 30.0
    var imageBoxHeight:CGFloat = 0.0
    var writeBoxHeightToEditing:CGFloat = 0.0
    var fullHeight:CGFloat = 0.0
    var isFrist:Bool = true
}

/* mode에 따라 내부 내용이 바뀜 */
class WriteViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, ImageBoxDelegate {

    let log = Logger.init(logPlace: WriteViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    private let imageManager = ImageFileManager.sharedInstance
    private let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
    @IBOutlet var navigartionBar: UINavigationItem!
    @IBOutlet var background: UIView!
    
    var writeBox = WriteBox()
    var writeState = WriteState()
    var imageBox = ImageBox()
    var imageData:Data? = nil
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* UI 및 기능 세팅 */
        setUpObserver()
        setNavigationTitle()
        makeNavigationItem()
        makeWriteBox()
        // scrollview content size, 테두리 버튼 - keyboardWillShow method에 설정
    }
    
    override func viewWillLayoutSubviews() {
        writeBox.writeSpace.becomeFirstResponder()
    }
    
    func makeNavigationItem()  {
        let fontManager = FontManager.sharedInstance
        let editBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 50, height: 30))
        editBtn.setTitle("save", for: .normal)
        editBtn.titleLabel!.font =  UIFont(name: fontManager.naviTitleFont, size: fontManager.naviItemFontSize)
        editBtn.addTarget(self, action: #selector(WriteViewController.clickSaveButton), for: .touchUpInside)
        let item = UIBarButtonItem(customView: editBtn)
        navigationItem.rightBarButtonItem = item
        
        let backBtn = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let back = UIImage(named: "back")?.withRenderingMode(.alwaysTemplate)
        backBtn.setImage(back, for: .normal)
        backBtn.tintColor = colorManager.tint
        backBtn.addTarget(self, action: #selector(WriteViewController.back), for: .touchUpInside)
        let item2 = UIBarButtonItem(customView: backBtn)
        
        navigationItem.leftBarButtonItem = item2
    }
    
    func back() {
        writeBox.writeSpace.endEditing(true)
        if 1 < writeBox.writeSpace.text.characters.count || (imageData != nil) {
            showAlert(message: "Unsaved changes will be discarded if you go back", haveCancel: true, doneHandler: { (UIAlertAction) in
               self.disappearPopAnimation()
            }, cancelHandler: nil)
        }
        else {
            disappearPopAnimation()
        }
    }
    /* action */
    
    @IBAction func clickSaveButton(_ sender: UIBarButtonItem) {
        
        showActivityIndicatory(start: true)
        
        // 날짜 및 내용 realm 저장
        let nowTimeStamp = TimeInterval().now()
        
        // (저장결과, 메세지)
        var trySaveDiary:(Bool, String) = (true, "")
        
        // 쓰기모드
        if (true == SharedMemoryContext.get(key: "isWriteMode") as! Bool) {
            trySaveDiary = diaryRepository.save(timeStamp: nowTimeStamp, content: writeBox.writeSpace.text, imageData: imageData)
        }
        // 수정 모드
        else if (false == SharedMemoryContext.get(key: "isWriteMode") as! Bool) {
            let diaryInfo = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
            let selectedDiaryID = diaryRepository.getSelectedDiaryID(section: diaryInfo.0, row: diaryInfo.1)
            let diary = diaryRepository.findOne(id: selectedDiaryID)
            let before = checkEditImageData(diary: diary!).0
            let after = checkEditImageData(diary: diary!).1
            trySaveDiary = diaryRepository.edit(id: selectedDiaryID, content: writeBox.writeSpace.text, before: before, after: after, newImageData: imageData)
        }
        
        let saveSuccess = trySaveDiary.0
        let saveMethodResultMessage = trySaveDiary.1
        
        if false == saveSuccess {
            showActivityIndicatory(start: false)
            showAlert(message: saveMethodResultMessage, haveCancel: false, doneHandler: nil, cancelHandler: nil)
        }
        else {
            // 저장 성공 시
            sendSaveMessage(succese: true)
            showActivityIndicatory(start: false)
            disappearPopAnimation()
        }
    }
    
    /** before: 원래 이미지가 있었는지 (diary.imageName)
     after: 새로운 이미지가 들어왔는지 (imageBox.image) */
    private func checkEditImageData(diary:Diary) -> (Bool, Bool) {
        var beforeAfter = (true, true)
        if nil == diary.imageName {
            beforeAfter.0 = false
        }
        if nil == imageBox.imageSpace.image {
            beforeAfter.1 = false
        }
        return beforeAfter
    }
    
    // save 관련 SharedMemoryContext 메세지 전달
    func sendSaveMessage(succese:Bool) {
        SharedMemoryContext.changeValue(key: "saveNewDairy", value: true)
    }
    
    override func photoPressed() {
        if false == haveImage() {
            changeWriteBoxHeight(height: writeState.fullHeight, option: .transitionCurlDown)
        }
        writeBox.writeSpace.endEditing(true)
        
        let photoMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.photoLibrary()
        })
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.camera()
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
            (alert: UIAlertAction!) -> Void in
            
        })
        
        photoMenu.addAction(libraryAction)
        photoMenu.addAction(cameraAction)
        photoMenu.addAction(cancelAction)
        
        self.present(photoMenu, animated: true, completion: nil)
    }
    
    func camera()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.camera
        myPickerController.cameraCaptureMode = .photo
        myPickerController.modalPresentationStyle = .fullScreen
        myPickerController.allowsEditing = true
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    func photoLibrary()
    {
        let myPickerController = UIImagePickerController()
        myPickerController.delegate = self
        myPickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        myPickerController.allowsEditing = true
        
        self.present(myPickerController, animated: true, completion: nil)
    }
    
    override func cancelPressed() {
        writeBox.endEditing(true)
        if false == haveImage() {
            changeWriteBoxHeight(height: writeState.fullHeight, option: .transitionCurlDown)
        }
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        changeWriteBoxHeight(height: writeState.writeBoxHeightToEditing, option: .transitionCurlUp)
        return true
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if false == haveImage() {
            makeImageBox(havePickerImage: true)
        }
        
        let chosenImage = info[UIImagePickerControllerEditedImage] as! UIImage
        setImageInImageBox(image: chosenImage)
        pickImageData(info: info)
        
        picker.dismiss(animated: true, completion: {
            self.changeWriteBoxHeight(height: self.writeState.writeBoxHeightToEditing, option: .transitionCurlDown)
            UIView.animate(withDuration: 3.0, delay: 0.0, options: .curveEaseOut, animations: {
            self.imageBox.alpha = 1.0
            }, completion: nil)
            
        })
    }
    
    
    func setImageInImageBox(image:UIImage) {
        if true == haveImage() {
            self.imageBox.imageSpace.image = nil
        }
        self.imageBox.imageSpace.image = image
        self.imageBox.imageSpace.contentMode = .scaleAspectFit
        self.imageBox.imageSpace.clipsToBounds = true
        self.imageBox.alpha = 0.0
    }
    
    func pickImageData(info: [String : Any]) {
        if true == haveImage() {
            self.imageData = nil
        }
        self.imageData = self.imageManager.getImageData(info: info)
        log.info(message: " imageData keep : \(String(describing: imageData))")
    }
    
    func haveImage() -> Bool {
        if (imageBox.imageSpace.image == nil) && (imageData == nil) {
            return false
        }
        return true
    }
    
    func deleteImage() {
        UIView.animate(withDuration: 0.5, delay: 0.0, options: .curveEaseOut, animations: {
            self.imageBox.alpha = 0.0
            self.changeWriteBoxHeight(height: self.writeState.fullHeight, option: .transitionCurlDown)
        }, completion: { _ in
            self.imageBox.imageSpace.image = nil
            self.imageData = nil
            self.imageBox.removeFromSuperview()
        })
    }
    
    
    
    /* UI & 애니메이션 */
    
    func getNavigationBarHeight() -> CGFloat {
        let naviHeight = SharedMemoryContext.get(key: "navigationbarHeight")
        if nil == naviHeight {
            return SharedMemoryContext.setAndGet(key: "navigationbarHeight", setValue: self.navigationController!.navigationBar.frame.height) as! CGFloat
        }
        else {
            return naviHeight as! CGFloat
        }
    }
    
    func setNavigationTitle() {
        if true == SharedMemoryContext.get(key: "isWriteMode") as! Bool {
            navigartionBar.title = "write page"
        }
        else {
            navigartionBar.title = "edit page"
        }
    }
    
    func changeWriteBoxHeight(height:CGFloat, option:UIViewAnimationOptions) {
        UIView.animate(withDuration: 0.3, delay: 0.0, options: option, animations: {
            self.writeBox.frame.size.height = height
            self.writeBox.writeSpace.frame = CGRect(x: self.writeState.margen, y: self.writeState.margen, width: self.view.frame.width - self.writeState.margen*2, height: height - self.writeState.margen*2)
        }, completion: nil)
        
    }
 
    func makeWriteBox() {
        let colorManager = ColorManager(theme: ThemeRepositroy.sharedInstance.get())
        view.backgroundColor = colorManager.paper
        let width = self.view.frame.width
        let height = self.view.frame.height - UIApplication.shared.statusBarFrame.height - (self.navigationController?.navigationBar.frame.size.height)!
        if 0.0 == writeState.keyboardHeight {
            writeState.fullHeight = height
            writeBox = WriteBox(frame: CGRect(x: 0, y: 0, width: width, height: writeState.fullHeight))
        }
        if 0.0 < writeState.keyboardHeight {
            writeState.writeBoxHeightToEditing = writeState.fullHeight - (writeState.keyboardHeight)
            writeState.imageBoxHeight = writeState.keyboardHeight
            changeWriteBoxHeight(height: writeState.writeBoxHeightToEditing, option: .transitionCurlUp)
        }
        
        self.automaticallyAdjustsScrollViewInsets = false
        
        addToolBar(textField: writeBox.writeSpace, barTintColor: colorManager.bar.withAlphaComponent(0.7), tintColor: colorManager.tint)
        
        // edit 모드일 때 설정
        if false == SharedMemoryContext.get(key: "isWriteMode") as! Bool {
            let diaryInfo = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
            let diaryID = diaryRepository.getSelectedDiaryID(section: diaryInfo.0, row: diaryInfo.1)
            let diary = diaryRepository.findOne(id: diaryID)
            writeBox.writeSpace.text = diary?.content
        }
        
        background.addSubview(writeBox)
    }
    
    func makeImageBox(havePickerImage:Bool) {
        let imageBoxY = writeState.writeBoxHeightToEditing
        imageBox = ImageBox(frame: CGRect(x: 0, y: imageBoxY, width: view.frame.width, height: writeState.imageBoxHeight))
        imageBox.delegate = self
        imageBox.imageSpace.image = nil
        // edit 모드일 때 설정
        if true == haveLoadImage(havePickerImage: havePickerImage) {
            let diaryInfo = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
            let diaryID = diaryRepository.getSelectedDiaryID(section: diaryInfo.0, row: diaryInfo.1)
            let diary = diaryRepository.findOne(id: diaryID)
            if nil != diary?.imageName {
                imageBox.imageSpace.image = imageManager.showImage(imageName: (diary?.imageName)!)
                imageBox.imageSpace.contentMode = .scaleAspectFit
            }
        }
        background.addSubview(imageBox)
        
    }
    
    func haveLoadImage(havePickerImage:Bool) -> Bool {
        // 수정모드로 들어왔을 때,
        // 처음에는 수정모드 확인 - 저장된 이미지 섹션 보여줘야함
        // 수정하는 도중에는 이미지 픽커에서 받은 이미지 섹션 만들때 이와 관계 없어도됨
        if true == isEditeMode() && false == havePickerImage {
            return true
        }
        return false
    }
    
    func isEditeMode() -> Bool {
        if false == SharedMemoryContext.get(key: "isWriteMode") as! Bool {
            return true
        }
        return false
    }
    
    func disappearPopAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func showActivityIndicatory(start:Bool) {
        let superViewHeight = self.view.frame.height
        let superViewWidth = self.view.frame.width
        let activityIndicatorSize: CGFloat = 40
        activityIndicator.frame = CGRect(x: superViewWidth / 2 - activityIndicatorSize / 2,
                                         y: superViewHeight / 2 - activityIndicatorSize / 2,
                                         width: activityIndicatorSize,
                                         height: activityIndicatorSize)
        activityIndicator.activityIndicatorViewStyle =
            UIActivityIndicatorViewStyle.whiteLarge
        self.view.addSubview(activityIndicator)
        if true == start {
            activityIndicator.startAnimating()
        }
        else {
            activityIndicator.stopAnimating()
            activityIndicator.isHidden = true
        }
        
    }
    
    func showAlert(message:String, haveCancel:Bool, doneHandler:((UIAlertAction) -> Swift.Void)?, cancelHandler:((UIAlertAction) -> Swift.Void)?)
    {
        let alertController = UIAlertController(title: "Notice", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "Done", style: UIAlertActionStyle.default,handler: doneHandler))
        if haveCancel {
            alertController.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default,handler: cancelHandler))
        }
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    /* NSNotification - 키보드 높이 구하기 */
    
    private func setUpObserver() {
        if 0.0 == writeState.keyboardHeight {
            NotificationCenter.default.addObserver(self, selector: .keyboardWillShow, name: .UIKeyboardWillShow, object: nil)
        }
    }
    
    @objc fileprivate func keyboardWillShow(notification:NSNotification) {
        if writeState.isFrist == true {
            if let keyboardRectValue = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                writeState.keyboardHeight = keyboardRectValue.height
                writeState.isFrist = false
                makeWriteBox()
                // 수정모드일 때
                if false == SharedMemoryContext.get(key: "isWriteMode") as! Bool {
                    let diaryInfo = SharedMemoryContext.get(key: "selectedDiaryInfo") as! (Int, Int)
                    let diaryID = diaryRepository.getSelectedDiaryID(section: diaryInfo.0, row: diaryInfo.1)
                    let diary = diaryRepository.findOne(id: diaryID)
                    if nil != diary?.imageName {
                        makeImageBox(havePickerImage: false)
                    }
                }
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}

