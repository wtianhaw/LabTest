# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'
use_frameworks!

def common_pods
  # Pods for LabTest
  pod 'SwiftyGif'
  pod 'KafkaRefresh'
  pod 'Kingfisher'
end

target 'LabTest' do
  # Comment the next line if you don't want to use dynamic frameworks
  common_pods
end


target 'LabTestTests' do
  inherit! :search_paths
  common_pods
  # Pods for testing
end

target 'LabTestUITests' do
  # Pods for testing
  common_pods
end
