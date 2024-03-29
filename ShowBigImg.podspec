#
#  Be sure to run `pod spec lint ShowBigImg.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "ShowBigImg"
  spec.version      = "0.0.16"
  spec.summary      = "仿微信朋友圈查看图片"
  
  spec.description  = <<-DESC
  showBigImg
  DESC

  spec.homepage     = "https://github.com/xingtianwuganqi/ShowImageDemo.git"

  spec.license      = { :type => "MIT" }
  spec.swift_versions = ['5.0', '5.1', '5.2', '5.3']

  spec.author       = { "jingjun" => "rxswift@126.com" }

  spec.platform     = :ios, "11.0"

  spec.source       = { :git => "https://github.com/xingtianwuganqi/ShowImageDemo.git", :tag => "#{spec.version}" }
  #spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  spec.source_files = "swiftText/Source/*.swift"

  spec.frameworks   = ["Foundation","UIKit","Photos"]
  
  spec.ios.dependency 'SDWebImage'
  spec.ios.dependency 'SDWebImageFLPlugin'
  spec.ios.dependency 'MBProgressHUD'
  spec.ios.dependency 'FLAnimatedImage'

  #spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'arm64' }
  spec.pod_target_xcconfig = { 'VALID_ARCHS' => 'x86_64 armv7 arm64' }

end
