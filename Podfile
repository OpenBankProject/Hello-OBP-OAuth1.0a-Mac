platform :osx, '10.9'
workspace 'HelloOBP-Mac-Pods'

use_frameworks!

target 'HelloOBP-Mac' do
  pod 'OAuthCore', :git => 'https://github.com/t0rst/OAuthCore.git'
  # ...t0rst fork of OAuthCore currently required by OBPKit...
  pod 'OBPKit', :git => 'https://github.com/OpenBankProject/OBPKit-iOSX.git'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
	target.build_configurations.each do |config|
	  config.build_settings['PODS_FRAMEWORK_BUILD_PATH'] = '$(BUILT_PRODUCTS_DIR)'
	end
  end
end
