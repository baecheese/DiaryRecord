# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'DiaryRecord' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  # Pods for MakingSpecialVideo
  pod 'RealmSwift'
  post_install do |installer|
  	installer.pods_project.targets.each do |target|
  		target.build_configurations.each do |config|
  			config.build_settings['SWIFT_VERSION'] = '3.0'
  		end
  	end
  end


  # Pods for DiaryRecord

  target 'DiaryRecordTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DiaryRecordUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
