//
//  ViewController.swift
//  iOS Puzzle
//
//  Created by Mazy on 2020/11/23.
//

import UIKit
import Photos

class ViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    // 拼图和分割选择
    private lazy var puzzleAndStyleView = PTPuzzleAndStyleView()
    // 图片资源数组
    private var imageSource: [UIImage] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let titleImageView = UIImageView(image: UIImage(named: "AmazingPuzzle"))
        navigationItem.titleView = titleImageView
        
        view.backgroundColor = .white
        
        puzzleAndStyleView.frame = contentView.bounds
        contentView.addSubview(puzzleAndStyleView)
    }
    
    @IBAction func selectPhotoAction(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func deleteLastImageSource(_ sender: Any) {
        if self.imageSource.count > 0 {        
            self.imageSource.removeLast()
        }

        puzzleAndStyleView.imageSource = self.imageSource

    }
    
    @IBAction func deleteAllImageSources(_ sender: Any) {
        self.imageSource.removeAll()
        self.puzzleAndStyleView.imageSource = self.imageSource
    }
    
    // 保存图片到本地相册
    @IBAction func saveToAlbumAction(_ sender: Any) {
        saveImage(puzzleAndStyleView.captureImage)
    }
    
    // 保存图片到本地相册
    func saveImage(_ image: UIImage?) {
        
        guard image != nil else { return }
        
        let saveImageClosure: (UIImage?) -> Void = { image in
            PHPhotoLibrary.shared().performChanges({
                if let image = image {
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }
            }, completionHandler: { isSuccess, error in
                if isSuccess {
                    print("保存成功")
                }
            })
        }
        
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .denied:
            print("被拒绝")
            // UIApplication.shared.openURL(URL(string: UIApplication.openSettingsURLString)!)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization({ (status) in
                if status == .authorized {
                    DispatchQueue.main.async {
                        saveImageClosure(image)
                    }
                }
            })
        case .authorized:
            saveImageClosure(image)
        default:
            saveImageClosure(image)
        }
    }
}

/// MARK: - UIImagePickerControllerDelegate & UINavigationControllerDelegate
extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageSource.append(image)
            puzzleAndStyleView.imageSource = self.imageSource
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
