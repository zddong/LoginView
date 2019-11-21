
Pod::Spec.new do |spec|

  spec.name         = "LoginDemoVC"
  spec.version      = "0.0.1"
  spec.summary      = "LoginDemoVC"
  spec.description  = <<-DESC
			     LoginDemoVC
                      DESC
  spec.homepage     = "https://github.com/zddong/LoginView.git"
  spec.license      = "MIT"
  spec.author             = { "850853654@qq.com" => "850853654@qq.com" }
  spec.source       = { :git => "https://github.com/zddong/LoginView.git", :tag => "#{spec.version}" }
  spec.module_name = 'LoginDemoVC'
  spec.platform   =  :ios,"8.0"
  spec.source_files  = "LoginDemoVC/*.{h,m}"
  spec.frameworks = "CoreLocation","Foundation", "CoreGraphics", "UIKit"
  spec.requires_arc = true

end
