platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'TomTomSDKExamples.xcworkspace'

install! 'cocoapods', warn_for_unused_master_specs_repo: false
use_frameworks!

plugin 'cocoapods-art', :sources => [
  'tomtom-sdk-cocoapods'
]

target 'TomTomSDKExamples' do
  pod 'TomTomSDKCommon', '0.26.1'
  pod 'TomTomSDKCommonUI', '0.26.1'
  pod 'TomTomSDKDefaultTextToSpeech', '0.26.1'
  pod 'TomTomSDKLocationProvider', '0.26.1'
  pod 'TomTomSDKMapDisplay', '0.26.1'
  pod 'TomTomSDKNavigation', '0.26.1'
  pod 'TomTomSDKNavigationEngines', '0.26.1'
  pod 'TomTomSDKNavigationOnline', '0.26.1'
  pod 'TomTomSDKNavigationUI', '0.26.1'
  pod 'TomTomSDKRoute', '0.26.1'
  pod 'TomTomSDKRoutePlanner', '0.26.1'
  pod 'TomTomSDKRoutePlannerOnline', '0.26.1'
  pod 'TomTomSDKRouteReplannerDefault', '0.26.1'
end
