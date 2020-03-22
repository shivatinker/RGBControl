# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

workspace 'RGBControl.xcworkspace'
target 'RGBConrol' do
#  project 'RGBControl.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for RGBConrol
  use_modular_headers!
  pod 'CocoaAsyncSocket'
  pod 'PlainPing'
#  pod 'CocoaAsyncSocket'

  target 'RGBConrolTests' do
    inherit! :search_paths
    # Pods for testing
  end

end


target 'RGBDriver' do
  project 'RGBDriver/RGBDriver.xcodeproj'
  # Comment the next line if you don't want to use dynamic frameworks
  # use_frameworks!

  # Pods for RGBConrol
  use_modular_headers!
  pod 'CocoaAsyncSocket'
  pod 'PlainPing'

end
