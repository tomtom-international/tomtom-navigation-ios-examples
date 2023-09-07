platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'TomTomSDKExamples.xcworkspace'

install! 'cocoapods', warn_for_unused_master_specs_repo: false
use_frameworks!

plugin 'cocoapods-art', :sources => [
  'tomtom-sdk-cocoapods'
]

target 'TomTomSDKExamples' do
  pod 'TomTomSDKCommon', '0.27.4'
  pod 'TomTomSDKCommonUI', '0.27.4'
  pod 'TomTomSDKDefaultTextToSpeech', '0.27.4'
  pod 'TomTomSDKLocationProvider', '0.27.4'
  pod 'TomTomSDKMapDisplay', '0.27.4'
  pod 'TomTomSDKNavigation', '0.27.4'
  pod 'TomTomSDKNavigationEngines', '0.27.4'
  pod 'TomTomSDKNavigationOnline', '0.27.4'
  pod 'TomTomSDKNavigationUI', '0.27.4'
  pod 'TomTomSDKRoute', '0.27.4'
  pod 'TomTomSDKRoutePlanner', '0.27.4'
  pod 'TomTomSDKRoutePlannerOnline', '0.27.4'
  pod 'TomTomSDKRouteReplannerDefault', '0.27.4'
end
