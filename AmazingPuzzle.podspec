Pod::Spec.new do |s|
  s.name         = 'AmazingPuzzle'
  s.version      = '0.0.1'
  s.summary      = 'AmazingPuzzle 主要用于将多张图片拼接成单张图片.'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/iMazy/AmazingPuzzle'
  s.author       = { 'Mazy' => 'mazy_ios@163.com' }
  s.ios.deployment_target = '9.0'
  s.swift_version = '5.0'
  s.source       = { :git => "https://github.com/iMazy/AmazingPuzzle.git", :tag => s.version }
  s.source_files = 'Sources/*.{swift}','Sources/Plists/*.{plist}'
  s.screenshots  = ["https://github.com/iMazy/AmazingPuzzle/blob/main/iOS%20Puzzle/amazing_cat_puzzle.png"]
  s.requires_arc = true
end
