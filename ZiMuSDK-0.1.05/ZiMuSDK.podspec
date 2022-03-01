Pod::Spec.new do |s|
  s.name = "ZiMuSDK"
  s.version = "0.1.05"
  s.summary = "A short description of ZiMuSDK."
  s.license = {"type"=>"MIT", "file"=>"LICENSE"}
  s.authors = {"ZiMu"=>"iOS@xyqb.com"}
  s.homepage = "https://github.com/TianJinZiMu/ZiMuSDK"
  s.description = "\u81EA\u7267SDK"
  s.source = { :path => '.' }

  s.ios.deployment_target    = '9.0'
  s.ios.vendored_framework   = 'ios/ZiMuSDK.framework'
end
