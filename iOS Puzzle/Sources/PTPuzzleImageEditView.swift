//
//  PTPuzzleImageEditView.swift
//  iOS Puzzle
//
//  Created by Mazy on 2020/11/23.
//

import UIKit

protocol PTPuzzleImageEditViewDelegate {
    func tapWithEditView(_ sender: PTPuzzleImageEditView)
}

class PTPuzzleImageEditView: UIView {

    var realCellArea: UIBezierPath?
    private var mainContentView: UIScrollView!
    private lazy var imageview: UIImageView = UIImageView()
    var tapDelegate: PTPuzzleImageEditViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initImageView()
    }
    
    func initImageView() {
        
        self.mainContentView = UIScrollView(frame: self.bounds)
        self.mainContentView.delegate = self
        self.mainContentView.showsVerticalScrollIndicator = false
        self.mainContentView.showsHorizontalScrollIndicator = false
        self.addSubview(self.mainContentView)
        
        self.imageview.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width * 2.5, height: UIScreen.main.bounds.width * 2.5)
        self.imageview.backgroundColor = .lightGray
        self.imageview.isUserInteractionEnabled = true
        self.mainContentView.addSubview(self.imageview)
        
        // Add gesture,double tap zoom imageView.
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapGesture.numberOfTapsRequired = 2
        self.imageview.addGestureRecognizer(doubleTapGesture)
        
        let minimumScale = self.frame.size.width / imageview.frame.size.width
        self.mainContentView.minimumZoomScale = minimumScale
        self.mainContentView.zoomScale = minimumScale
        
//        self.showsHorizontalScrollIndicator = false
//        self.showsVerticalScrollIndicator = false
        self.clipsToBounds = true
        
    }
    
    @objc func handleDoubleTap(_ gesture: UIGestureRecognizer) {
        let newScale = self.mainContentView.zoomScale * 1.2
        let zoomRect: CGRect = self.zoomRectForScale(newScale, withCenter: gesture.location(in: self.imageview))
        self.mainContentView.zoom(to: zoomRect, animated: true)
    }
    
    private func zoomRectForScale(_ scale: CGFloat, withCenter center: CGPoint) -> CGRect {
        var zoomRect: CGRect = .zero
        let tempScale = scale == 0 ? 1 : scale
        
        zoomRect.size.height = self.frame.size.height / tempScale
        zoomRect.size.width  = self.frame.size.width  / tempScale
        zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0)
        zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImageViewData(_ imageData: UIImage?) {
    
        imageview.image = imageData
        
        guard let image = imageData else {
            return
        }
        var rect  = CGRect.zero
//        var scale: CGFloat = 1.0
        var w: CGFloat = 0.0
        var h: CGFloat = 0.0
        if self.mainContentView.frame.width > self.mainContentView.frame.height {
            w = self.mainContentView.frame.width
            h = w * image.size.height / image.size.width
            if h < self.mainContentView.bounds.height {
                h = self.mainContentView.frame.height
                w = h * image.size.width / image.size.height
            }
        } else {
            h = self.mainContentView.bounds.height
            w = h * image.size.width / image.size.height
            if w < self.mainContentView.frame.size.width {
                w = self.mainContentView.frame.size.width
                h = w * image.size.height / image.size.width
            }
        }
        rect.size = CGSize(width: w, height: h)

//        var scale_w: CGFloat = w / image.size.width
//        var scale_h: CGFloat = h / image.size.height
//        if (w > self.frame.size.width || h > self.frame.size.height) {
//            scale_w = w / self.frame.size.width
//            scale_h = h / self.frame.size.height
//            if (scale_w > scale_h) {
//                scale = 1 / scale_w
//            } else {
//                scale = 1 / scale_h
//            }
//        }
//
//        if (w <= self.frame.size.width || h <= self.frame.size.height) {
//            scale_w = w / self.frame.size.width;
//            scale_h = h / self.frame.size.height;
//            if (scale_w > scale_h)
//            {
//                scale = scale_h
//            } else {
//                scale = scale_w
//            }
//        }
        
        let lockQueue = DispatchQueue(label: "com.test.LockQueue")
        lockQueue.sync {
            self.imageview.frame = rect
            let maskLayer = CAShapeLayer()
            maskLayer.path = self.realCellArea?.cgPath
            maskLayer.fillColor = UIColor.white.cgColor
            maskLayer.frame = rect
            self.layer.mask = maskLayer
            self.mainContentView.setZoomScale(0.2, animated: true)
            self.setNeedsLayout()
        }

    }
    
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        let contained = realCellArea?.contains(point) ?? false
        self.tapDelegate?.tapWithEditView(self)
        return contained
    }
}

extension PTPuzzleImageEditView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageview
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        scrollView.setZoomScale(scale, animated: false)
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first?.location(in: self.superview) {
            self.imageview.center = touch
        }
    }
}
