Pod::Spec.new do |spec|
	spec.name         = "MTIAPurchase"
	spec.version      = "1.0.3"
	spec.summary      = "A Simple, Lightweight and Safe framework for In App Purchase."
	spec.swift_version = ['5.1', '5.2', '5.3', '5.4', '5.5']
  
	spec.homepage     = "https://hominhtuong.com/"
	spec.license      = { :type => "MIT", :file => "LICENSE" }



	spec.author             = { "Minh Tường" => "admin@hominhtuong.com" }
	spec.platform     = :ios, "13.0"
	spec.ios.deployment_target = '13.0'
	spec.ios.framework  = 'UIKit'
	spec.dependency 'Google-Mobile-Ads-SDK'

	spec.source       = { :git => "https://github.com/hominhtuong/MTIAPurchase.git", :tag => "#{spec.version}" }

	spec.source_files  = 'IAPurchase/MTSources/IAP/Internal/*.swift', 'IAPurchase/MTSources/IAP/*.swift', 'IAPurchase/MTSources/AdmobManager/*.swift'

end
