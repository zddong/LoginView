Pod::Spec.new do |s|

  s.name         = "LoginDemoVC"
  s.version      = "0.1.8"
  s.summary      = "LoginDemoVC"
  s.description  = <<-DESC
  LoginDemoVC
                   DESC
  s.homepage     = "https://github.com/zddong/LoginView.git"
  s.license      = "MIT"				#开源协议
  s.source       = { :git => "https://github.com/zddong/LoginView.git" }
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license      = "MIT"
  s.author             = { "850853654@qq.com" => "850853654@qq.com" }
  s.platform   =  :ios,"9.0"
  s.source       = { :git => "https://github.com/zddong/LoginView.git", :tag => "#{s.version}" }
  s.source_files  =  "LoginDemoVC/*.{h,m}"
  s.resources  =  "LoginDemoVC/*.{xib}"
  s.requires_arc = true
  s.exclude_files = "LoginDemoVC/Exclude"
  s.frameworks = "CoreLocation","Foundation", "CoreGraphics", "UIKit"
  s.dependency "SDWebImage"
  s.dependency "AFNetworking"
  s.dependency "MBProgressHUD"
  # s.public_header_files = "WPButton/**/*.h"
end
