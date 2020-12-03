//
//  PTPuzzleContentView.swift
//  iOS Puzzle
//
//  Created by Mazy on 2020/11/24.
//

import UIKit

enum PTPicCountFlag: Int {
    
    case one     = 1
    case two     = 2
    case three   = 3
    case four    = 4
    case five    = 5
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
    
    var styleString: String {
        switch self {
        case .two:
            return ""
        case .three:
            return "3"
        case .four:
            return "4"
        case .five:
            return "5"
        default:
            return ""
        }
    }
}

class PTPuzzleContentView: UIView {

    private var currentFlag: PTPicCountFlag = .defalut
    private var styleIndexs: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .white
    }
    
    func updatePuzzleWithStyleIndex(_ styleIndex: Int, images: [UIImage]) {
        
        self.subviews.forEach({ $0.removeFromSuperview() })
        
        if images.count <= 0 {
            return
        }
        
        let currentFlag = PTPicCountFlag(rawValue: images.count) ?? .defalut
        
        if currentFlag.flagString.count <= 0 {
            
            let editView = PTPuzzleImageEditView(frame: self.bounds)
            let bezierPath: UIBezierPath = UIBezierPath(rect: self.bounds.insetBy(dx: 10, dy: 10))
                //UIBezierPath(roundedRect: self.contentView.bounds, cornerRadius: self.contentView.bounds.width / 2)
            editView.clipsToBounds = true
            editView.tapDelegate = self
            editView.realCellArea = bezierPath
            if let image = images.first {
                editView.setImageViewData(image)
            }
            
            self.addSubview(editView)
            
            return
        }
        
        let picCountFlag = currentFlag
        
        let styleName = "number_\(picCountFlag)_style_\(styleIndex)"

        var nsDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: styleName, ofType: "plist") {
            nsDictionary = NSDictionary(contentsOfFile: path)
        }

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
        
        for (index, dict) in subViewArray.enumerated() {
            
            var rect: CGRect = .zero
            let bezierPath: UIBezierPath = UIBezierPath()
            let image = images[index]
            if let points = dict["pointArray"] as? [String] {
                
                rect = rectWithArray(points, and: superSize)
                                
                for (index, pointStr) in points.enumerated() {
                    var point = getPointFromString(pointStr)
                    point = pointScaleWithPoint(point, scale: 2.0)
                    point.x = (point.x * self.frame.width / superSize.width) - rect.origin.x
                    point.y = (point.y * self.bounds.height / superSize.height) - rect.origin.y

                    if index == 0 {
                        bezierPath.move(to: point)
                    } else {
                        bezierPath.addLine(to: point)
                    }
                }
                bezierPath.close()
                
                let editView = PTPuzzleImageEditView(frame: rect)
                editView.clipsToBounds = true
                editView.tapDelegate = self
                editView.realCellArea = bezierPath
                editView.setImageViewData(image)
                
                self.addSubview(editView)
            }
        }
    }
    
    // scale CGSize
    private func sizeScaleWithSize(_ size: CGSize, scale: CGFloat) -> CGSize {
        let tempScale = scale <= 0 ? 1 : scale
        var retSize: CGSize = .zero
        retSize.width = size.width / tempScale
        retSize.height = size.height / tempScale
        return retSize
    }

    // point array to CGRect
    private func rectWithArray(_ array: [String], and superSize: CGSize) -> CGRect {
        
        var rect: CGRect = .zero
        var minX: CGFloat = CGFloat(Int.max)
        var maxX: CGFloat = 0
        var minY:CGFloat = CGFloat(Int.max)
        var maxY: CGFloat = 0
        
        for string in array {
            
            let point = self.getPointFromString(string)
            minX = min(point.x, minX)
            maxX = max(point.x, maxX)
            minY = min(point.y, minY)
            maxY = max(point.y, maxY)
            rect = CGRect(x: minX, y: minY, width: maxX - minX, height: maxY - minY)
        }
        
        rect = rectScaleWithRect(rect, withScale: 2)
        rect.origin.x = rect.origin.x * self.frame.size.width/superSize.width;
        rect.origin.y = rect.origin.y * self.frame.size.height/superSize.height;
        rect.size.width = rect.size.width * self.frame.size.width/superSize.width;
        rect.size.height = rect.size.height * self.frame.size.height/superSize.height;
        
        return rect
    }
    
    // scale CGRect Value
    private func rectScaleWithRect(_ rect: CGRect, withScale scale: CGFloat) -> CGRect {
        let tempScale = scale <= 0 ? 1 : scale
        var retRect: CGRect = .zero
        
        retRect.origin.x = rect.origin.x / tempScale
        retRect.origin.y = rect.origin.y / tempScale
        retRect.size.width  = rect.size.width / tempScale
        retRect.size.height = rect.size.height / tempScale
        return retRect
    }
    
    // get CGPoint from string eg: "{10, 10}"
    private func getPointFromString(_ string: String) -> CGPoint {
        let removeLeft = string.replacingOccurrences(of: "{", with: "")
        let removeRight = removeLeft.replacingOccurrences(of: "}", with: "")
        let pureString = removeRight.replacingOccurrences(of: " ", with: "")
        let points = pureString.components(separatedBy: ",")
        return CGPoint(x: convertStringToCGFloatValue(points[0]), y: convertStringToCGFloatValue(points[1]))
    }

    // scale CGPoint value
    private func pointScaleWithPoint(_ point: CGPoint, scale: CGFloat) -> CGPoint {
        let tempScale = scale <= 0 ? 1 : scale
        var  retPoint: CGPoint = .zero
        retPoint.x = point.x / tempScale
        retPoint.y = point.y / tempScale
        return retPoint
    }
    
    // convert string "10" to CGFloat value 10
    private func convertStringToCGFloatValue(_ string: String) -> CGFloat {
        guard let doubleValue = Double(string) else {
          return 0
        }
        return CGFloat(doubleValue)
    }

}

/// MARK: - PTPuzzleImageEditViewDelegate
extension PTPuzzleContentView: PTPuzzleImageEditViewDelegate {
    func tapWithEditView(_ sender: PTPuzzleImageEditView) {
        
    }
}
