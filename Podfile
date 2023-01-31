# Uncomment the next line to define a global platform for your project
platform :ios, '10.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings["ONLY_ACTIVE_ARCH"] = "NO"
    end
  end
end

target 'AccountBook' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for AccountBook
  pod "MonthYearPicker", '~> 4.0.2'
  pod 'DTZFloatingActionButton'

  pod 'Firebase/Analytics'
  pod 'Firebase/Firestore'
  pod 'Firebase/Auth'
  pod 'RxSwift', '~> 6.5.0'

  target 'AccountBookTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'AccountBookUITests' do
    # Pods for testing
  end

end
