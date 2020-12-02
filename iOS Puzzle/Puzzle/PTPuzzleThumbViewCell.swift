//
//  PTPuzzleThumbViewCell.swift
//  iOS Puzzle
//
//  Created by Mazy on 2020/11/24.
//

import UIKit

class PTPuzzleThumbViewCell: UICollectionViewCell {
    
    public lazy var thumbImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    func setupUI() {
        thumbImageView.frame = self.bounds.insetBy(dx: 2, dy: 2)
        contentView.addSubview(thumbImageView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        thumbImageView.frame = self.bounds.insetBy(dx: 2, dy: 2)
    }
    
    override var isSelected: Bool {
        didSet {
            contentView.backgroundColor = isSelected ? UIColor.red : UIColor.white
        }
    }
}
