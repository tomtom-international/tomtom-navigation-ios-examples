platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'TomTomSDKExamples.xcworkspace'

install! 'cocoapods', warn_for_unused_master_specs_repo: false
use_frameworks!

plugin 'cocoapods-art', :sources => [
  'tomtom-sdk-cocoapods'
]

target 'TomTomSDKExamples' do
  pod 'TomTomSDKCommon', '0.28.2'
  pod 'TomTomSDKCommonUI', '0.28.2'
  pod 'TomTomSDKDefaultTextToSpeech', '0.28.2'
  pod 'TomTomSDKLocationProvider', '0.28.2'
  pod 'TomTomSDKMapDisplay', '0.28.2'
  pod 'TomTomSDKNavigation', '0.28.2'
  pod 'TomTomSDKNavigationEngines', '0.28.2'
  pod 'TomTomSDKNavigationOnline', '0.28.2'
  pod 'TomTomSDKNavigationUI', '0.28.2'
  pod 'TomTomSDKRoute', '0.28.2'
  pod 'TomTomSDKRoutePlanner', '0.28.2'
  pod 'TomTomSDKRoutePlannerOnline', '0.28.2'
  pod 'TomTomSDKRouteReplannerDefault', '0.28.2'
end
