//
//  PTPuzzleStyleSelectView.swift
//  iOS Puzzle
//
//  Created by Mazy on 2020/11/24.
//

import UIKit

protocol PTPuzzleStyleSelectViewDelegate {
    func puzzleStyleSelectViewDidSelect(_ index: Int)
}

class PTPuzzleStyleSelectView: UIView {

    public var delegate: PTPuzzleStyleSelectViewDelegate?
    
    public var currentImageCount: Int = 0 {
        didSet {
            styleIndexs = currentImageCount > 1 ? 6 : 0
            self.collectionView.reloadData()
            self.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .init(rawValue: 0))
        }
    }
    
    private lazy var flowLayout: UICollectionViewFlowLayout = {
        let fLayout = UICollectionViewFlowLayout()
        fLayout.scrollDirection = .horizontal
        fLayout.minimumLineSpacing = 5
        fLayout.minimumInteritemSpacing = 5
        return fLayout
    }()
    
    private lazy var collectionView: UICollectionView = {
        let cView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        cView.delegate = self
        cView.dataSource = self
        cView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return cView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private var styleIndexs: Int = 0
    
    private func setupUI() {
        self.collectionView.register(PTPuzzleThumbViewCell.self, forCellWithReuseIdentifier: "PTPuzzleThumbViewCell")
        self.collectionView.backgroundColor = UIColor.clear
        self.addSubview(self.collectionView)
        self.collectionView.reloadData()
        self.collectionView.selectItem(at: IndexPath(row: 0, section: 0), animated: true, scrollPosition: .init(rawValue: 0))
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.collectionView.frame = self.bounds
    }
}

/// MARK: - UICollectionViewDataSource, UICollectionViewDelegate
extension PTPuzzleStyleSelectView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleIndexs
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: PTPuzzleThumbViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "PTPuzzleThumbViewCell", for: indexPath) as! PTPuzzleThumbViewCell
        let currentCountFlag = self.currentImageCount == 2 ? "" : "\(self.currentImageCount)"
        cell.thumbImageView.image = UIImage(named: "makecards_puzzle\(currentCountFlag)_storyboard\(indexPath.row + 1)_icon")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(indexPath.row)
        delegate?.puzzleStyleSelectViewDidSelect(indexPath.row)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (self.bounds.width - 20 - 5 * 5) / 6, height: self.bounds.height)
    }
}
