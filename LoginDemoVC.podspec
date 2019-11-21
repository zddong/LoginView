
Pod::Spec.new do |s|

  s.name         = "LoginDemoVC"
  s.version      = "0.0.1"
  s.summary      = "LoginDemoVC"
  s.description  = <<-DESC
			     LoginDemoVC
                      DESC
  s.homepage     = "https://github.com/zddong/LoginView.git"
  s.license      = "MIT"
  s.author             = { "850853654@qq.com" => "850853654@qq.com" }
  s.source       = { :git => "https://github.com/zddong/LoginView.git", :tag => "#{s.version}" }
  s.source_files  = "LoginDemoVC/*"
  s.frameworks = "UIKit"
  s.requires_arc = true

end
