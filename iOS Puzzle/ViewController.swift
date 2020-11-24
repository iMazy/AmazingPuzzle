//
//  ViewController.swift
//  iOS Puzzle
//
//  Created by Mazy on 2020/11/23.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
        
    private lazy var puzzleContentView = PTPuzzleContentView(frame: contentView.bounds)
    private lazy var puzzleStyleView = PTPuzzleStyleSelectView()
    
    private var imageSource: [UIImage] = []
    private var currentFlag: PTPicCountFlag = .defalut
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .green
        
        self.puzzleContentView.frame = self.contentView.bounds
        contentView.addSubview(self.puzzleContentView)
        
        puzzleStyleView.delegate = self
        puzzleStyleView.frame = CGRect(x: 20, y: self.contentView.frame.maxY + 30, width: 300, height: 60)
        view.addSubview(puzzleStyleView)
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
//        if imageSource.count >= 1 && imageSource.count <= 5 {
            currentFlag = PTPicCountFlag(rawValue: imageSource.count) ?? .defalut
            self.puzzleStyleView.currentImageCount = self.imageSource.count
            self.puzzleContentView.updatePuzzleWithStyleIndex(1, images: self.imageSource)
//        }
    }
    
    @IBAction func deleteAllImageSources(_ sender: Any) {
        self.imageSource.removeAll()

        self.puzzleStyleView.currentImageCount = self.imageSource.count
        self.puzzleContentView.updatePuzzleWithStyleIndex(1, images: self.imageSource)
    }

}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageSource.append(image)
            self.puzzleStyleView.currentImageCount = self.imageSource.count
            self.puzzleContentView.updatePuzzleWithStyleIndex(1, images: self.imageSource)
        }
        picker.dismiss(animated: true, completion: nil)
    }
}

extension ViewController: PTPuzzleStyleSelectViewDelegate {
    func puzzleStyleSelectViewDidSelect(_ index: Int) {
        self.puzzleContentView.updatePuzzleWithStyleIndex(index + 1, images: self.imageSource)
    }
}
