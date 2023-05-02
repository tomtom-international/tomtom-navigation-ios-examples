platform :ios, '13.0'

ENV['COCOAPODS_DISABLE_STATS'] = 'true'

workspace 'TomTom SDK Examples.xcworkspace'

install! 'cocoapods', warn_for_unused_master_specs_repo: false
use_frameworks!

plugin 'cocoapods-art', :sources => [
  'tomtom-sdk-cocoapods'
]

TOMTOM_SDK_VERSION = '0.2.3404'

target 'TomTom SDK Examples' do
  pod 'TomTomSDKCommon', TOMTOM_SDK_VERSION
  pod 'TomTomSDKCommonUI', TOMTOM_SDK_VERSION
  pod 'TomTomSDKDefaultTextToSpeech', TOMTOM_SDK_VERSION
  pod 'TomTomSDKLocationProvider', TOMTOM_SDK_VERSION
  pod 'TomTomSDKMapDisplay', TOMTOM_SDK_VERSION
  pod 'TomTomSDKNavigation', TOMTOM_SDK_VERSION
  pod 'TomTomSDKNavigationEngines', TOMTOM_SDK_VERSION
  pod 'TomTomSDKNavigationUI', TOMTOM_SDK_VERSION
  pod 'TomTomSDKRoute', TOMTOM_SDK_VERSION
  pod 'TomTomSDKRoutePlanner', TOMTOM_SDK_VERSION
  pod 'TomTomSDKRoutePlannerOnline', TOMTOM_SDK_VERSION
  pod 'TomTomSDKRouteReplannerDefault', TOMTOM_SDK_VERSION
end
