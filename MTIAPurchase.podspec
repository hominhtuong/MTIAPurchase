Pod::Spec.new do |s|
  s.name             = 'MTIAPurchase'
  s.version          = '1.0.1'
  s.summary          = 'MTIAPurchase for iOS'
  s.swift_version = ['5.1', '5.2', '5.3', '5.4', '5.5', '5.6', '5.7']
  s.description  = <<-DESC
  This CocoaPods library is software development kit for iOS. Easy way to manager purchase inapp . 
                   DESC

  s.homepage         = 'https://github.com/hominhtuong/MTIAPurchase'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'hominhtuong' => 'minhtuong2502@gmail.com' }
  s.source           = { :git => 'https://github.com/hominhtuong/MTIAPurchase.git', :tag => s.version.to_s }
  s.social_media_url = 'https://facebook.com/minhtuongitc'
  s.ios.deployment_target = '13.0'

  s.source_files = 'Sources/*.swift'
  s.static_framework   = true
  s.deprecated = false
  s.frameworks   = 'UIKit'
  s.dependency     'SwiftyStoreKit'
end
