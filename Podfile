platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'TomTom SDK Examples.xcworkspace'

install! 'cocoapods', warn_for_unused_master_specs_repo: false
use_frameworks!

plugin 'cocoapods-art', :sources => [
  'tomtom-sdk-cocoapods'
]

target 'TomTom SDK Examples' do  
  pod 'TomTomSDKCommon', '0.18.1'
  pod 'TomTomSDKCommonUI', '0.18.1'
  pod 'TomTomSDKDefaultTextToSpeech', '0.18.1'
  pod 'TomTomSDKLocationProvider', '0.18.1'
  pod 'TomTomSDKMapDisplay', '0.18.1'
  pod 'TomTomSDKNavigation', '0.18.1'
  pod 'TomTomSDKNavigationEngines', '0.18.1'
  pod 'TomTomSDKNavigationUI', '0.18.1'
  pod 'TomTomSDKRoute', '0.18.1'
  pod 'TomTomSDKRoutePlanner', '0.18.1'
  pod 'TomTomSDKRoutePlannerOnline', '0.18.1'
  pod 'TomTomSDKRouteReplannerDefault', '0.18.1'
end
