Pod::Spec.new do |s|
  s.name         = "BCUIImagePicker"
  s.version      = "0.0.1"
  s.summary      = "Library for images picker"
  s.homepage     = "https://github.com/sebarina/BCUIImagePicker"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "sebarina xu" => "sebarinaxu@gmail.com" }

  s.ios.deployment_target = "8.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/sebarina/BCUIImagePicker.git", :tag => "0.0.1" }
  s.source_files  = "source/*"
  s.resources = ["Images/*"]
  s.requires_arc = true

end
