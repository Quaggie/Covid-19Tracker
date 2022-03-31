source 'https://github.com/cocoapods/specs'
platform :ios, '12.0'
inhibit_all_warnings!

target 'Covid19Tracker' do
  use_frameworks!

  # Pods for Covid19Tracker
  pod 'Charts', '3.4.0'
  pod 'Kingfisher', '5.13.3'
  pod 'Firebase/Analytics', '6.21.0'

  target 'Covid19Tracker_unit_tests' do
  end
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
      # Supress warnings
      config.build_settings['GCC_WARN_INHIBIT_ALL_WARNINGS'] = "YES"
      config.build_settings['SWIFT_SUPPRESS_WARNINGS'] = "YES"
    end
  end
end
