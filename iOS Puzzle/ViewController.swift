//
//  ViewController.swift
//  iOS Puzzle
//
//  Created by Mazy on 2020/11/23.
//

import UIKit

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
}

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
