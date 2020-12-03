# AmazingPuzzle 主要用于将多张图片以各种形式拼接成单张图片

<img src="https://github.com/iMazy/AmazingPuzzle/blob/main/iOS%20Puzzle/amazing_cat_puzzle.png" width=100%>

[![License](https://img.shields.io/badge/license-MIT-blue.svg?style=flat)](http://mit-license.org)
[![Platform](http://img.shields.io/badge/platform-iOS-lightgrey.svg?style=flat)](https://developer.apple.com/resources/)
[![Language](https://img.shields.io/badge/swift-5.0-orange.svg)](https://developer.apple.com/swift)

## 特点
- 支持1~5张图片
- 每张单独的照片支持移动缩放
- 每组图片有6中风格类型
- 纯Swift 语言开发, 简单集成使用


## CocoaPods

```
  pod 'AmazingPuzzle'
```

# Requirements
* iOS 9.0+
* Swift 5.x
* Xcode 12.x


## Usage

```
/// 初始化
let puzzleAndStyleView = PTPuzzleAndStyleView()
    
// 设置位置和大小
puzzleAndStyleView.frame = CGRect(x: 0, y: 0, width: 500, height: 300)
    
// 添加到父试图
view.addSubview(puzzleAndStyleView)
     
// 设置图片数据源
puzzleAndStyleView.imageSource = [UIImage(named: "ImageName1"), UIImage(named: "ImageName2"), UIImage(named: "ImageName3")]
     
// 获取拼图后的 UIImage
let cropImage = puzzleAndStyleView.captureImage 
```


## Demo Effect




