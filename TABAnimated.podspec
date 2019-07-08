Pod::Spec.new do |s|

  #库名，和文件名一样
  s.name         = "TABAnimated"

  #tag方式：填tag名称
  #commit方式：填commit的id
  s.version      = "2.1.3"

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
  s.source       = { :git => "https://github.com/tigerAndBull/LoadAnimatedDemo-ios.git", :tag => "2.1.3" }
  # s.source       = { :git => "https://github.com/tigerAndBull/LoadAnimatedDemo-ios.git", :commit => "e05513581c80a7c899e65de48e8fe474a64734eb" }
     
  s.source_files = "AnimatedDemo/AnimatedDemo/TABAnimated/Animation/*.{h,m}", "AnimatedDemo/AnimatedDemo/TABAnimated/Layer/*.{h,m}", "AnimatedDemo/AnimatedDemo/TABAnimated/Manager/*.{h,m}", 
  "AnimatedDemo/AnimatedDemo/TABAnimated/ControlModel/*.{h,m}", "AnimatedDemo/AnimatedDemo/TABAnimated/*.{h,m}"

  #Animation文件夹
  # s.subspec 'Animation' do |animation|
  #   animation.source_files = 'AnimatedDemo/AnimatedDemo/TABAnimated/Animation/*.{h,m}'
  # end

  # #Gobal文件夹
  # s.subspec 'Gobal' do |gobal|
  #   gobal.source_files = 'AnimatedDemo/AnimatedDemo/TABAnimated/Gobal/*.{h,m}'
  #   gobal.dependency 'TABAnimated/Animation'
  # end

  #Layer文件夹
  # s.subspec 'Layer' do |layer|
  #   layer.source_files = 'AnimatedDemo/AnimatedDemo/TABAnimated/Layer/*.{h,m}'
  # end

  #Model文件夹
  # s.subspec 'Model' do |model|
  #   model.source_files = 'AnimatedDemo/AnimatedDemo/TABAnimated/Model/*.{h,m}'
  # end

  #Manager文件夹
  # s.subspec 'Manager' do |manager|
  #   manager.source_files = 'AnimatedDemo/AnimatedDemo/TABAnimated/Manager/*.{h,m}'
  #   manager.dependency 'TABAnimated/Animation'
  #   manager.dependency 'TABAnimated/Layer'
  #   manager.dependency 'TABAnimated/Model'
  # end

end
