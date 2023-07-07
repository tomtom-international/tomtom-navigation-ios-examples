platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'TomTomSDKExamples.xcworkspace'

install! 'cocoapods', warn_for_unused_master_specs_repo: false
use_frameworks!

plugin 'cocoapods-art', :sources => [
  'tomtom-sdk-cocoapods'
]

target 'TomTomSDKExamples' do
  pod 'TomTomSDKCommon', '0.21.1'
  pod 'TomTomSDKCommonUI', '0.21.1'
  pod 'TomTomSDKDefaultTextToSpeech', '0.21.1'
  pod 'TomTomSDKLocationProvider', '0.21.1'
  pod 'TomTomSDKMapDisplay', '0.21.1'
  pod 'TomTomSDKNavigation', '0.21.1'
  pod 'TomTomSDKNavigationEngines', '0.21.1'
  pod 'TomTomSDKNavigationUI', '0.21.1'
  pod 'TomTomSDKRoute', '0.21.1'
  pod 'TomTomSDKRoutePlanner', '0.21.1'
  pod 'TomTomSDKRoutePlannerOnline', '0.21.1'
  pod 'TomTomSDKRouteReplannerDefault', '0.21.1'
  
  # Offline
  pod 'TomTomSDKDataManagementOffline', '0.21.1'
  pod 'TomTomSDKMapDisplayDataProviderOffline', '0.21.1'
  pod 'TomTomSDKStyleProviderOffline', '0.21.1'
end
