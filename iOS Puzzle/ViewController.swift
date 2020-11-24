//
//  ViewController.swift
//  iOS Puzzle
//
//  Created by Mazy on 2020/11/23.
//

import UIKit

enum PTPicCountFlag: Int {
    case one = 1
    case two = 2
    case three = 3
    case four =  4
    case five = 5
    case defalut = 0
    
    var flagString: String {
        switch self {
        case .two:
            return "two"
        case .three:
            return "three"
        case .four:
            return "four"
        case .five:
            return "five"
        default:
            return ""
        }
    }
}

class ViewController: UIViewController {
    
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var imageSource: [UIImage] = []
    private var currentFlag: PTPicCountFlag = .defalut
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        flowLayout.itemSize = CGSize(width: 68, height: 60)
        flowLayout.minimumLineSpacing = 10
        flowLayout.minimumInteritemSpacing = 10
        flowLayout.scrollDirection = .horizontal
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        
//        collectionView.register(PTPuzzleThumbViewCell.self, forCellWithReuseIdentifier: "PTPuzzleThumbViewCell")
        // Do any additional setup after loading the view.
        view.backgroundColor = .green

//        updatePuzzleWithCountTag("four", styleIndex: "1")
    }
    
    @IBAction func selectPhotoAction(_ sender: UIButton) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func updatePuzzleWithCountTag(_ tag: String, styleIndex: String) {
        
        self.contentView.subviews.forEach({ $0.removeFromSuperview() })
        
        let picCountFlag = tag// "four"
        let styleIndex = styleIndex //"2"
        let styleName = "number_\(picCountFlag)_style_\(styleIndex)"

        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: styleName, ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }
//        print(nsDictionary)
        guard let styleDict = nsDictionary else {
            return
        }
        
        guard let superViewInfo = styleDict["SuperViewInfo"] as? NSDictionary else {
            return
        }
        
        guard let subViewArray = styleDict["SubViewArray"] as? [NSDictionary] else {
            return
        }
        
        guard let superViewSize = superViewInfo["size"] as? String else { return }
        
        let superViewPoint = getPointFromString(superViewSize)
        
        var superSize: CGSize = CGSize(width: superViewPoint.x, height: superViewPoint.y)
        
        // 父视图大小
        superSize = sizeScaleWithSize(superSize, scale: 2.0)
        
//      print("super size ====== \(superSize)")
        for (index, dict) in subViewArray.enumerated() {
            
            var rect: CGRect = .zero
            let bezierPath: UIBezierPath = UIBezierPath()
            let image = self.imageSource[index]
            if let points = dict["pointArray"] as? [String] {
                
                rect = rectWithArray(points, and: superSize)
                                
                for (index, pointStr) in points.enumerated() {
                    var point = getPointFromString(pointStr)
                    point = pointScaleWithPoint(point, scale: 2.0)
                    point.x = (point.x * self.contentView.frame.width / superSize.width) - rect.origin.x
                    point.y = (point.y * self.contentView.bounds.height / superSize.height) - rect.origin.y
                    print(point)
                    if index == 0 {
                        bezierPath.move(to: point)
                    } else {
                        bezierPath.addLine(to: point)
                    }
                }
                bezierPath.close()
                
                let editView = PTPuzzleImageEditView(frame: rect)
                print("bezierPath = \(bezierPath)")
                editView.clipsToBounds = true
                editView.tapDelegate = self
                editView.realCellArea = bezierPath
                editView.setImageViewData(image)
                
                contentView.addSubview(editView)
            }
        }
    }
    
    private func sizeScaleWithSize(_ size: CGSize, scale: CGFloat) -> CGSize {
        let tempScale = scale <= 0 ? 1 : scale
        var  retSize: CGSize = .zero
        retSize.width = size.width / tempScale
        retSize.height = size.height / tempScale
        return retSize
    }

    func rectWithArray(_ array: [String], and superSize: CGSize) -> CGRect {
        
        var rect: CGRect = .zero
        var minX: CGFloat = CGFloat(Int.max)
        var maxX: CGFloat = 0
        var minY:CGFloat = CGFloat(Int.max)
        var maxY: CGFloat = 0
        
        for string in array {
            
            let point = self.getPointFromString(string)
            if point.x <= minX {
                minX = point.x
            }
            
            if point.x >= maxX {
                maxX = point.x
            }
            
            if point.y <= minY {
                minY = point.y
            }
            
            if point.y >= maxY {
                maxY = point.y
            }
            
            rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        }
        
        rect = rectScaleWithRect(rect, withScale: 2)
            
        rect.origin.x = rect.origin.x * self.contentView.frame.size.width/superSize.width;
        rect.origin.y = rect.origin.y * self.contentView.frame.size.height/superSize.height;
        rect.size.width = rect.size.width * self.contentView.frame.size.width/superSize.width;
        rect.size.height = rect.size.height * self.contentView.frame.size.height/superSize.height;
        
        return rect
        
    }
    
    private func rectScaleWithRect(_ rect: CGRect, withScale scale: CGFloat) -> CGRect {
        let tempScale = scale <= 0 ? 1 : scale
        var retRect: CGRect = .zero
        
        retRect.origin.x = rect.origin.x / tempScale
        retRect.origin.y = rect.origin.y / tempScale
        retRect.size.width  = rect.size.width / tempScale
        retRect.size.height = rect.size.height / tempScale
        return retRect
    }
    
    func getPointFromString(_ string: String) -> CGPoint {
        
        let removeLeft = string.replacingOccurrences(of: "{", with: "")
        let removeRight = removeLeft.replacingOccurrences(of: "}", with: "")
        let pureString = removeRight.replacingOccurrences(of: " ", with: "")
        let points = pureString.components(separatedBy: ",")
        return CGPoint(x: points[0].cgFloatValue(), y: points[1].cgFloatValue())
    }

    func pointScaleWithPoint(_ point: CGPoint, scale: CGFloat) -> CGPoint {
        let tempScale = scale <= 0 ? 1 : scale
        var  retPoint: CGPoint = .zero
        retPoint.x = point.x / tempScale
        retPoint.y = point.y / tempScale
        return retPoint
    }
}

extension String {

  func cgFloatValue() -> CGFloat {
    guard let doubleValue = Double(self) else {
      return 0
    }
    return CGFloat(doubleValue)
  }
}

extension ViewController: PTPuzzleImageEditViewDelegate {
    func tapWithEditView(_ sender: PTPuzzleImageEditView) {
        
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PTPuzzleThumbViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PTPuzzleThumbViewCell", for: indexPath) as! PTPuzzleThumbViewCell
        let styleIndex: String = currentFlag == .two ? "" : "\(currentFlag.rawValue)"
        cell.thumbImageView.image = UIImage(named: "makecards_puzzle\(styleIndex)_storyboard\(indexPath.row + 1)_icon")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        updatePuzzleWithCountTag(self.currentFlag.flagString, styleIndex: "\(indexPath.row + 1)")
    }
}

extension ViewController: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//        print(info[UIImagePickerController.InfoKey.originalImage])
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageSource.append(image)
            if imageSource.count >= 1 && imageSource.count <= 5 {
                currentFlag = PTPicCountFlag(rawValue: imageSource.count) ?? .defalut
                updatePuzzleWithCountTag(currentFlag.flagString, styleIndex: "\(1)")
                self.collectionView.reloadData()
            }
        }
        picker.dismiss(animated: true, completion: nil)
    }
}
