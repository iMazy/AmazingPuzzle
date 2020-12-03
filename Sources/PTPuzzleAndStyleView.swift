//
//  PTPuzzleAndStyleView.swift
//  iOS Puzzle
//
//  Created by Admin on 2020/11/25.
//

import UIKit

public class PTPuzzleAndStyleView: UIView {
    /// 拼图主视图
    private lazy var puzzleContentView = PTPuzzleContentView()
    /// 风格选择视图
    private lazy var puzzleStyleView = PTPuzzleStyleSelectView()
    /// 图片资源数组
    public var imageSource: [UIImage] = [] {
        didSet {
            self.puzzleStyleView.currentImageCount = imageSource.count
            self.puzzleContentView.updatePuzzleWithStyleIndex(1, images: imageSource)
        }
    }
    /// 风格选择视图高度
    public var styleViewHight: CGFloat = 60
    /// 捕获图片
    public var captureImage: UIImage? {
        return puzzleContentView.snapshot()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()

        puzzleContentView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - styleViewHight - 20)
        puzzleStyleView.frame = CGRect(x: 20, y: self.frame.maxY - styleViewHight - 10, width: self.bounds.width - 40, height: styleViewHight)
    }
    
    private var styleIndexs: Int = 0
    
    private func setupUI() {
            
        self.puzzleContentView.frame = CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height - styleViewHight - 20)
        addSubview(self.puzzleContentView)
        
        puzzleStyleView.frame = CGRect(x: 20, y: self.frame.maxY - styleViewHight - 10, width: self.bounds.width - 40, height: styleViewHight)
        puzzleStyleView.delegate = self
        addSubview(puzzleStyleView)
    }
}

/// MARK: - PTPuzzleStyleSelectViewDelegate
extension PTPuzzleAndStyleView: PTPuzzleStyleSelectViewDelegate {
    func puzzleStyleSelectViewDidSelect(_ index: Int) {
        self.puzzleContentView.updatePuzzleWithStyleIndex(index + 1, images: self.imageSource)
    }
}

private extension UIView {
    
    /// Create snapshot
    ///
    /// - parameter rect: The `CGRect` of the portion of the view to return. If `nil` (or omitted),
    ///                   return snapshot of the whole view.
    ///
    /// - returns: Returns `UIImage` of the specified portion of the view.
    
    func snapshot(of rect: CGRect? = nil) -> UIImage? {
        // snapshot entire view
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, isOpaque, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let wholeImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // if no `rect` provided, return image of whole view
        
        guard let image = wholeImage, let rect = rect else { return wholeImage }
        
        // otherwise, grab specified `rect` of image
        
        let scale = image.scale
        let scaledRect = CGRect(x: rect.origin.x * scale, y: rect.origin.y * scale, width: rect.size.width * scale, height: rect.size.height * scale)
        guard let cgImage = image.cgImage?.cropping(to: scaledRect) else { return nil }
        return UIImage(cgImage: cgImage, scale: scale, orientation: .up)
    }
}
