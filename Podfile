platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'TomTom SDK Examples.xcworkspace'

install! 'cocoapods', warn_for_unused_master_specs_repo: false
use_frameworks!

plugin 'cocoapods-art', :sources => [
  'tomtom-sdk-cocoapods'
]

target 'TomTom SDK Examples' do  
  pod 'TomTomSDKCommon', '0.14.5'
  pod 'TomTomSDKCommonUI', '0.14.5'
  pod 'TomTomSDKDefaultTextToSpeech', '0.14.5'
  pod 'TomTomSDKLocationProvider', '0.14.5'
  pod 'TomTomSDKMapDisplay', '0.14.5'
  pod 'TomTomSDKNavigation', '0.14.5'
  pod 'TomTomSDKNavigationEngines', '0.14.5'
  pod 'TomTomSDKNavigationUI', '0.14.5'
  pod 'TomTomSDKRoute', '0.14.5'
  pod 'TomTomSDKRoutePlanner', '0.14.5'
  pod 'TomTomSDKRoutePlannerOnline', '0.14.5'
  pod 'TomTomSDKRouteReplannerDefault', '0.14.5'
end
