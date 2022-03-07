#
# Be sure to run `pod lib lint ZiMuSDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
    s.name             = 'ZiMuSDK'
    s.version          = '0.1.14'
    s.summary          = 'A short description of ZiMuSDK.'
    
    # This description is used to generate tags and improve search results.
    #   * Think: What does it do? Why did you write it? What is the focus?
    #   * Try to keep it short, snappy and to the point.
    #   * Write the description between the DESC delimiters below.
    #   * Finally, don't worry about the indent, CocoaPods strips it!
    
    s.description      = '自牧SDK,包含基础支付功能及回调，子组件可支持常用微信、支付宝等方式的拓展'
    
    s.homepage         = 'https://github.com/TianJinZiMu/ZiMuSDK'
    # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'ZiMu' => 'iOS@xyqb.com' }
    s.source           = { :git => 'https://github.com/TianJinZiMu/ZiMuSDK.git', :tag => s.version.to_s }
    # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
    
    s.requires_arc = true
    
    s.static_framework = true

    s.vendored_frameworks = 'Framework/**/*.{a}' # 指定 .framework 文件
    
    s.ios.deployment_target = "9.0"
    
#    s.source_files = 'ZiMuSDK/Classes/**/*'
    
    # s.resource_bundles = {
    #   'ZiMuSDK' => ['ZiMuSDK/Assets/*.png']
    # }
    
    # s.public_header_files = 'Pod/Classes/**/*.h'
    # s.frameworks = 'UIKit', 'MapKit'
    # s.dependency 'AFNetworking', '~> 2.3'
    s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
    
    s.subspec 'ZiMuPayBasic' do |ss|
        ss.source_files = 'ZiMuSDK/Classes/ZiMuPayBasic/*.{h,m}'
        ss.frameworks = 'SystemConfiguration','CFNetwork'
        ss.dependency 'ZiMuSDK/ZiMuPayChannels'

    end
    
    #subspec
    s.subspec 'ZiMuPayChannels' do |ss|
        ss.source_files ='ZiMuSDK/Classes/ZiMuPayChannels/**/*.{h,m}'
        ss.libraries = 'c++', 'sqlite3', 'z'
        ss.frameworks = 'CoreTelephony', 'SystemConfiguration', 'CoreMotion'
        ss.dependency 'WechatOpenSDK'
        ss.dependency 'AliPay'
    end

 
end
