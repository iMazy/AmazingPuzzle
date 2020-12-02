//
//  PTPuzzleAndStyleView.swift
//  iOS Puzzle
//
//  Created by Admin on 2020/11/25.
//

import UIKit

class PTPuzzleAndStyleView: UIView {
    
    private lazy var puzzleContentView = PTPuzzleContentView()
    private lazy var puzzleStyleView = PTPuzzleStyleSelectView()
    
    public var imageSource: [UIImage] = [] {
        didSet {
            self.puzzleStyleView.currentImageCount = imageSource.count
            self.puzzleContentView.updatePuzzleWithStyleIndex(1, images: imageSource)
        }
    }
    
    public var styleViewHight: CGFloat = 60
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    override func layoutSubviews() {
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

