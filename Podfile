platform :ios, '16.0'
use_frameworks!
inhibit_all_warnings!

target 'Demo Pet App' do
  pod 'RxSwift'
  pod 'RxDataSources'
  pod 'RxCoreLocation'
  pod 'PKHUD'
  
  target 'Demo Pet AppTests' do
    pod 'RxTest'
  end
end

post_install do |installer|
  
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      if Gem::Version.new('12.0') > Gem::Version.new(config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'])
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '12.0'
      end
    end
  end
end
