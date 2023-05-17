platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'TomTom SDK Examples.xcworkspace'

install! 'cocoapods', warn_for_unused_master_specs_repo: false
use_frameworks!

plugin 'cocoapods-art', :sources => [
  'tomtom-sdk-cocoapods'
]

target 'TomTom SDK Examples' do  
  pod 'TomTomSDKCommon', '0.2.3404'
  pod 'TomTomSDKCommonUI', '0.2.3404'
  pod 'TomTomSDKDefaultTextToSpeech', '0.2.3404'
  pod 'TomTomSDKLocationProvider', '0.2.3404'
  pod 'TomTomSDKMapDisplay', '0.2.3404'
  pod 'TomTomSDKNavigation', '0.2.3404'
  pod 'TomTomSDKNavigationEngines', '0.2.3404'
  pod 'TomTomSDKNavigationUI', '0.2.3404'
  pod 'TomTomSDKRoute', '0.2.3404'
  pod 'TomTomSDKRoutePlanner', '0.2.3404'
  pod 'TomTomSDKRoutePlannerOnline', '0.2.3404'
  pod 'TomTomSDKRouteReplannerDefault', '0.2.3404'
end
