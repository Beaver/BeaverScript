inhibit_all_warnings!
use_frameworks!

platform :osx, '10.10'

target 'BeaverScript' do
  plugin 'cocoapods-rome'

  pod 'Commander'
  pod 'BeaverCodeGen', :git => 'git@github.com:Beaver/BeaverCodeGen.git'
end

post_install do |installer|
  puts("Set Swift version to 3.0")
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0'
    end
  end
end