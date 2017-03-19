//
// Created by 배지영 on 2017. 3. 16..
// Copyright (c) 2017 baecheese. All rights reserved.
//

import Foundation
import RealmSwift

class ImageFileManager: NSObject {

    private let log = Logger(logPlace: ImageFileManager.self)

    private let fileManager = FileManager.default

    private override init() {
        super.init()
    }

    static let sharedInstance: ImageFileManager = ImageFileManager()

    /** image picker 에서 이미지 선택 후 저장을 위한 데이터로 바꿀 때 사용*/
    func getImageData(info:[String : Any]) -> Data {
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        let data = UIImageJPEGRepresentation(image, 0.7)
        return data!
    }

    private func getDocumentsDirectoryURL() -> URL {
        let paths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    private func getDocumentsDirectoryWithFileURL(fileName:String) -> URL {
        return URL(fileURLWithPath: getDocumentsDirectoryURL().path + "/" + fileName)
    }

    private func getImageFilePath(imageName:String) -> String? {
        let filePath:String? = getDocumentsDirectoryWithFileURL(fileName: imageName).path
        if (filePath == nil) {
            return nil
        }
        return filePath
    }

    private func isNotExistImage(imageName:String) -> Bool {
        let imagePath = getImageFilePath(imageName: imageName)
        if imagePath == nil {
            return true
        }
        return false == fileManager.fileExists(atPath: imagePath!)
    }

    func saveImage(data:Data, id:Int) -> String {
        let imageName = "\(id).jpeg"
        let isNotExists = isNotExistImage(imageName: imageName)
        log.debug(message: "\(imageName) is not exists \(isNotExists)")

        if isNotExists {
            let filename = getDocumentsDirectoryURL().appendingPathComponent(imageName)
            log.debug(message: "fileName: \(filename)")
            try? data.write(to: filename)
        }
        return imageName
    }

    func deleteImageFile(imageName:String?) {
        if false == isNotExistImage(imageName: imageName!) {
            do {
                // path 를 checkExistsImage와 같은 형태로 확인
                try fileManager.removeItem(atPath: getImageFilePath(imageName: imageName!)!)
                log.info(message: "이미지 삭제 성공")
            }
            catch {
                log.error(message: "image delete error : \(error)")
            }
        }
        else {
            log.debug(message: "이미 삭제되거나 없는 이미지 입니다.")
        }
    }
    
    func deleteImageFile(diaryID:Int) {
        let imageName = "\(diaryID).jpeg"
        deleteImageFile(imageName: imageName)
    }

    func showImage(imageName:String) -> UIImage? {
        if isNotExistImage(imageName: imageName) {
            return nil
        }
        let imageURL = getDocumentsDirectoryWithFileURL(fileName: imageName)
        return UIImage(contentsOfFile: imageURL.path)
    }
    
    
    
    /** <test용> Documents 내의 모든 파일 리스트 보기 */
    private func getListAllFileFromDocumentsFolder() -> [String]
    {
        let url:URL = getDocumentsDirectoryURL()
        do {
            return try fileManager.contentsOfDirectory(atPath: url.path)
        } catch {
            return []
        }
    }
    
    /** <test용> Documents 내의 모든 이미지 파일 리스트 보기 */
    func getImageFileAllList() -> [String] {
        let fileList = getListAllFileFromDocumentsFolder()
        var result:[String] = []
        for fileName in fileList {
            if nil != fileName.range(of: ".jpeg") {
                result.append(fileName)
            }
        }
        return result
    }
    
    /** <test용> Documents 내의 모든 이미지 파일 삭제하기 */
    func deleteAllImageFile() {
        let fileList = getListAllFileFromDocumentsFolder()
        for fileName in fileList {
            do {
                // path 를 checkExistsImage와 같은 형태로 확인
                try fileManager.removeItem(atPath: getImageFilePath(imageName: fileName)!)
                log.info(message: "이미지 삭제 성공")
            }
            catch {
                log.error(message: "image delete error : \(error)")
            }
        }
    }
}
