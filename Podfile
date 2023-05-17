platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'TomTom SDK Examples.xcworkspace'

install! 'cocoapods', warn_for_unused_master_specs_repo: false
use_frameworks!

plugin 'cocoapods-art', :sources => [
  'tomtom-sdk-cocoapods'
]

target 'TomTom SDK Examples' do  
  pod 'TomTomSDKCommon', '0.13.0'
  pod 'TomTomSDKCommonUI', '0.13.0'
  pod 'TomTomSDKDefaultTextToSpeech', '0.13.0'
  pod 'TomTomSDKLocationProvider', '0.13.0'
  pod 'TomTomSDKMapDisplay', '0.13.0'
  pod 'TomTomSDKNavigation', '0.13.0'
  pod 'TomTomSDKNavigationEngines', '0.13.0'
  pod 'TomTomSDKNavigationUI', '0.13.0'
  pod 'TomTomSDKRoute', '0.13.0'
  pod 'TomTomSDKRoutePlanner', '0.13.0'
  pod 'TomTomSDKRoutePlannerOnline', '0.13.0'
  pod 'TomTomSDKRouteReplannerDefault', '0.13.0'
end
