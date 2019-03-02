Pod::Spec.new do |s|

  #库名，和文件名一样
  s.name         = "TABAnimated"

  #tag方式：填tag名称
  #commit方式：填commit的id
  s.version      = "1.9.0"

  #库的简介
  s.summary      = "TABAnimated是一个ios平台上的网络过渡动画(骨架屏)的封装"

  #库的描述
  s.description  = <<-DESC
  TABAnimated是一个ios平台上的网络过渡动画(骨架屏)的封装，目前仅支持oc
                           DESC
  #库的远程仓库地址
  s.homepage     = "https://github.com/tigerAndBull/LoadAnimatedDemo-ios"

  #版权方式
  s.license = { :type => "MIT", :file => "LICENSE" }

  #库的作者
  s.author             = { "tigerAndBull" => "1429299849@qq.com" }

  #依赖于ios平台上的8.0
  s.platform     = :ios, "8.0"

  #库的地址
  s.source       = { :git => "https://github.com/tigerAndBull/LoadAnimatedDemo-ios.git", :commit => "2791f50ab042a621ec74f1607ae9d65e88474c2a" }
     
  s.source_files = "AnimatedDemo/AnimatedDemo/TABAnimated/**/*.{h,m}"


end
