#
#  Be sure to run `pod spec lint TABAnimated.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "TABAnimated"

  s.version      = "1.0.5"

  s.summary      = "TABAnimated是一个ios平台上的网络过渡动画的封装"

  s.description  = <<-DESC
  TABAnimated是一个ios平台上利用Runtime运行时机制的网络过渡动画的封装,你可以很轻松地集成它。
                           DESC

  s.homepage     = "https://www.jianshu.com/u/c2ea902ee897"

  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "tigerAndBull" => "1429299849@qq.com" }

  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/tigerAndBull/LoadAnimatedDemo-ios.git", :tag => "#{s.version}" }

  s.source_files  = "TABAnimated/**/*.{h,m}"

end
