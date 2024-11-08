# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Bdc' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Bdc
  pod 'FSCalendar'
  pod 'FittedSheets', '2.6.1'
  pod 'SwiftConfettiView'
  pod 'SwiftLint'
  pod 'AcknowList'
  pod 'DGCharts'
  pod 'IncrementableLabel'
  
  # ignore all warnings from all pods
  inhibit_all_warnings!

  target 'BdcTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'BdcUITests' do
    # Pods for testing
  end

end

post_install do |installer|
        installer.pods_project.targets.each do |target|
          target.build_configurations.each do |config|
            if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
              target.build_configurations.each do |config|
                  config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
              end
            end
          end
        end
      end

