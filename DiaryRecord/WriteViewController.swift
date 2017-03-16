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

private extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}


struct WriteState {
    let margen:CGFloat = 30.0
    let margenOnKeyborad:CGFloat = 60.0
    var writeBoxHeight:CGFloat = 0.0
    var writeSpaceHeight:CGFloat = 0.0
    var keyboardHeight:CGFloat = 0.0
    
    var isFrist:Bool = true
}

/* mode에 따라 내부 내용이 바뀜 */
class WriteViewController: UIViewController, WriteBoxDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    let log = Logger.init(logPlace: WriteViewController.self)
    private let diaryRepository = DiaryRepository.sharedInstance
    private let imageManager = ImageFileManager.sharedInstance
    
    @IBOutlet var navigartionBar: UINavigationItem!
    @IBOutlet var backgroundScroll: UIScrollView!
    var writeBox = WriteBox()
    var writeState = WriteState()
    var imageBox = UIImageView()
    var imageData:Data? = nil
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /* UI 및 기능 세팅 */
        setUpObserver()
        setNavigationTitle()
        makeWriteBox()
        makeImageBox()
        
        // scrollview content size, 테두리 버튼 - keyboardWillShow method에 설정
    }
    
    override func viewWillLayoutSubviews() {
        writeBox.writeSpace.becomeFirstResponder()
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
            let seletedDiaryID = SharedMemoryContext.get(key: "seletedDiaryID") as! Int
            let diary = diaryRepository.findOne(id: seletedDiaryID)
            let before = checkEditImageData(diary: diary!).0
            let after = checkEditImageData(diary: diary!).1
            trySaveDiary = diaryRepository.edit(id: seletedDiaryID, content: writeBox.writeSpace.text, before: before, after: after, newImageData: imageData)
        }
        
        let saveSuccess = trySaveDiary.0
        let saveMethodResultMessage = trySaveDiary.1
        
        if false == saveSuccess {
            showActivityIndicatory(start: false)
            showAlert(message: saveMethodResultMessage)
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
        if nil == imageBox.image {
            beforeAfter.1 = false
        }
        return beforeAfter
    }
    
    // save 관련 SharedMemoryContext 메세지 전달
    func sendSaveMessage(succese:Bool) {
        SharedMemoryContext.changeValue(key: "saveNewDairy", value: true)
    }
    
    func onTouchUpInsideWriteSpace() {
        log.info(message: "🍔 up")
        writeBox.writeSpace.endEditing(false)
    }
    
    func clickBackButton() {
        log.info(message: "🍔 click Back Button")
        writeBox.writeSpace.endEditing(true)
    }
    
    override func photoPressed() {
        let photoMenu = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let libraryAction = UIAlertAction(title: "Library", style: .default, handler: {
            (alert: UIAlertAction!) -> Void in
            self.photoLibrary()
        })
        let cameraAction = UIAlertAction(title: "Camera roll", style: .default, handler: {
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
        // 사진 삭제시, 화면 사진 삭제 && imagepath = nil
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageBox.image = chosenImage
        imageBox.contentMode = .scaleAspectFill
        imageBox.clipsToBounds = true
        imageData = imageManager.getImageData(info: info)
        log.info(message: " 🌟 \(imageData)")
        
        picker.dismiss(animated: true, completion: nil)
        
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
 
    func makeWriteBox() {
        
        let writeWidth = self.view.frame.size.width - (writeState.margen * 2)
        writeState.writeBoxHeight = self.view.frame.size.height - (writeState.margen + getNavigationBarHeight()) // 네비 빼야함
        
        writeBox = WriteBox(frame: CGRect(x: writeState.margen, y: writeState.margen, width: writeWidth, height: writeState.writeBoxHeight))
        // textview 높이 설정
        writeState.writeSpaceHeight = writeState.writeBoxHeight - (writeState.keyboardHeight + writeState.margenOnKeyborad)
        writeBox.writeSpace.frame.size.height = writeState.writeSpaceHeight
        //writeBox.backgroundColor = .blue
        self.automaticallyAdjustsScrollViewInsets = false
        
        addToolBar(textField: writeBox.writeSpace)
        writeBox.delegate = self
        
        // edit 모드일 때 설정
        if false == SharedMemoryContext.get(key: "isWriteMode") as! Bool {
            let diaryID = SharedMemoryContext.get(key: "seletedDiaryID") as! Int
            let diary = diaryRepository.findOne(id: diaryID)
            writeBox.writeSpace.text = diary?.content
        }
        
        backgroundScroll.addSubview(writeBox)
    }
    
    func setBackgroundContentsSize() {
        backgroundScroll.contentSize = CGSize(width: self.view.frame.size.width, height: writeState.writeBoxHeight + writeState.keyboardHeight)
    }
    
    func makeBackButton() {
        let width = self.view.frame.size.width
        let height = self.backgroundScroll.contentSize.height
        let up = UIButton(frame: CGRect(x: 0, y: 0, width: width, height: writeState.margen))
        let right = UIButton(frame: CGRect(x: width - writeState.margen, y: 0, width: writeState.margen, height: height))
        let left = UIButton(frame: CGRect(x: 0, y: 0, width: writeState.margen, height: height))
        let downY:CGFloat = up.frame.height + writeBox.writeSpace.frame.height + imageBox.frame.height
        let down = UIButton(frame: CGRect(x: 0, y: downY, width: width, height: height - downY))
        
        /*
        up.backgroundColor = .red
        right.backgroundColor = .black
        left.backgroundColor = .yellow
        down.backgroundColor = .black
         */
        
        let buttonArray = [up, right, left, down]
        
        for button in buttonArray {
            button.addTarget(self, action: #selector(WriteViewController.clickBackButton), for: .touchUpInside)
            backgroundScroll.addSubview(button)
        }
        
    }
    
    func makeImageBox() {
        let imageBoxHeight = writeBox.frame.size.height - writeState.writeSpaceHeight - 100
        imageBox.frame = CGRect(x: 0, y: writeState.writeSpaceHeight, width: writeBox.frame.size.width, height: imageBoxHeight)
        imageBox.isUserInteractionEnabled = true
        /*
        imageBox.layer.borderColor = UIColor.yellow.cgColor
        imageBox.layer.borderWidth = 0.5
         */
        
        // edit 모드일 때 설정
        if false == SharedMemoryContext.get(key: "isWriteMode") as! Bool {
            let diaryID = SharedMemoryContext.get(key: "seletedDiaryID") as! Int
            let diary = diaryRepository.findOne(id: diaryID)
            if nil != diary?.imageName {
                imageBox.image = imageManager.showImage(imageName: (diary?.imageName)!)
            }
        }
        
        writeBox.addSubview(imageBox)
    }
    
    func makeImageDeleteButton() {
        let margen:CGFloat = 5.0
        let deleteSize:CGFloat = 38.0
        let fontSize:CGFloat = 28.0
        let deleteButton = UIButton(frame: CGRect(x: writeBox.frame.size.width - deleteSize - margen, y: margen, width: deleteSize, height: deleteSize))
//        deleteButton.backgroundColor = .yellow
        deleteButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: fontSize)
        deleteButton.setTitle("X", for: .normal)
        deleteButton.titleLabel?.textColor = .white
        deleteButton.addTarget(self, action: #selector(WriteViewController.deleteImage), for: .touchUpInside)
        imageBox.addSubview(deleteButton)
    }
    
    func deleteImage() {
        imageBox.image = nil
        imageData = nil
    }
    
    
    func disappearPopAnimation() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.type = kCATransitionFade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        _ = self.navigationController?.popToRootViewController(animated: false)
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
    
    func showAlert(message:String)
    {
        let alertController = UIAlertController(title: "error", message:
            message, preferredStyle: UIAlertControllerStyle.alert)
        alertController.addAction(UIAlertAction(title: "확인", style: UIAlertActionStyle.default,handler: nil))
        
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
                makeImageBox()
                makeImageDeleteButton()
                setBackgroundContentsSize()
                makeBackButton()
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

