//  © 2023 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

// System modules
import Combine
import CoreLocation
import Foundation
import SwiftUI

// TomTomSDK modules
import TomTomSDKCommon
import TomTomSDKCommonUI
import TomTomSDKDataManagementOffline
import TomTomSDKDefaultTextToSpeech
import TomTomSDKLocationProvider
import TomTomSDKMapDisplay
import TomTomSDKMapDisplayDataProviderOffline
import TomTomSDKNavigation
import TomTomSDKNavigationEngines
import TomTomSDKNavigationUI
import TomTomSDKRoute
import TomTomSDKRoutePlanner
import TomTomSDKRoutePlannerOnline
import TomTomSDKRouteReplannerDefault
import TomTomSDKStyleProviderOffline

/// This example shows how to build a simple navigation application using the TomTom Navigation SDK for iOS.
/// The application downloads a region, displays a map and shows the user’s location.
/// After the user selects a destination with a long press, the app plans a route and draws it on the map.
/// Navigation is started automatically using the route simulation.
/// The application will display upcoming maneuvers, remaining distance, estimated time of arrival (ETA), current speed, and speed limit information.
struct OfflineNavigationContent: View {
    var body: some View {
        OfflineMainView()
    }
}

// MARK: - OfflineNavigationController

/// An observable class to handle flows between modules
final class OfflineNavigationController: ObservableObject {
    // MARK: Lifecycle

    convenience init() {
        let textToSpeech = SystemTextToSpeechEngine()
        let routePlanner = TomTomSDKRoutePlannerOnline.OnlineRoutePlanner(apiKey: Keys.apiKey)
        let routeReplanner = RouteReplannerFactory.create(routePlanner: routePlanner, replanningPolicy: .findBetter)
        let locationProvider = DefaultCLLocationProvider()
        let simulatedLocationProvider = SimulatedLocationProvider(delay: .tt.seconds(1))
        let navigationConfiguration = NavigationConfiguration(
            apiKey: Keys.apiKey,
            locationProvider: simulatedLocationProvider,
            routeReplanner: routeReplanner,
            betterProposalAcceptanceMode: .automatic
        )
        let navigation = Navigation(configuration: navigationConfiguration)
        let navigationModel = TomTomSDKNavigationUI.NavigationView.ViewModel(navigation, tts: textToSpeech)

        self.init(
            locationProvider: locationProvider,
            simulatedLocationProvider: simulatedLocationProvider,
            routePlanner: routePlanner,
            navigation: navigation,
            navigationModel: navigationModel
        )
    }

    init(
        locationProvider: LocationProvider,
        simulatedLocationProvider: SimulatedLocationProvider,
        routePlanner: TomTomSDKRoutePlannerOnline.OnlineRoutePlanner,
        navigation: TomTomSDKNavigation.Navigation,
        navigationModel: TomTomSDKNavigationUI.NavigationView.ViewModel
    ) {
        self.locationProvider = locationProvider
        self.simulatedLocationProvider = simulatedLocationProvider
        self.routePlanner = routePlanner
        self.navigation = navigation
        navigationViewModel = navigationModel

        self.navigation.addProgressObserver(self)
        self.navigation.addRouteObserver(self)
        locationProvider.start()
    }

    // MARK: Internal

    let locationProvider: LocationProvider
    let simulatedLocationProvider: SimulatedLocationProvider
    let routePlanner: TomTomSDKRoutePlannerOnline.OnlineRoutePlanner
    let navigation: TomTomSDKNavigation.Navigation
    let navigationViewModel: TomTomSDKNavigationUI.NavigationView.ViewModel

    let displayedRouteSubject = PassthroughSubject<TomTomSDKRoute.Route?, Never>()
    let progressOnRouteSubject = PassthroughSubject<Measurement<UnitLength>, Never>()
    let mapMatchedLocationProvider = PassthroughSubject<LocationProvider, Never>()

    @Published
    var showNavigationView: Bool = false
}

// MARK: NavigationProgressObserver

/// Allows observing progress changes.
extension OfflineNavigationController: NavigationProgressObserver {
    func didUpdateProgress(progress: RouteProgress) {
        progressOnRouteSubject.send(progress.distanceAlongRoute)
    }
}

// MARK: NavigationRouteObserver

/// Allows observing route changes.
extension OfflineNavigationController: NavigationRouteObserver {
    func didDeviateFromRoute(currentRoute _: TomTomSDKRoute.Route, location _: TomTomSDKLocationProvider.GeoLocation) {}

    func didProposeRoutePlan(routePlan _: TomTomSDKNavigationEngines.RoutePlan, reason _: TomTomSDKNavigationEngines.RouteReplanningReason) {}

    func didReplanRoute(replannedRoute: TomTomSDKRoute.Route, reason _: TomTomSDKNavigationEngines.RouteReplanningReason) {
        displayedRouteSubject.send(replannedRoute)
    }

    func didChangeRoutes(navigatedRoutes _: TomTomSDKNavigation.NavigatedRoutes) {}

    func didReplanRouteOnLanguageChange(replannedRoute _: TomTomSDKRoute.Route, reason _: TomTomSDKNavigationEngines.RouteReplanningReason, language _: Locale) {}
}

// MARK: - MainView

struct OfflineMainView: View {
    // MARK: Internal

    var body: some View {
        ZStack(alignment: .bottom) {
            TomTomOfflineMapView(contentInsets: $contentInsets, offlineNavigationController: offlineNavigationController)
            if offlineNavigationController.showNavigationView {
                NavigationView(
                    offlineNavigationController.navigationViewModel,
                    action: offlineNavigationController.onNavigationViewAction
                )
            }
        }
        .onDisappear {
            offlineNavigationController.stopNavigating()
        }
    }

    // MARK: Private

    @State
    private var contentInsets = EdgeInsets()

    @StateObject
    var offlineNavigationController = OfflineNavigationController()
}

// MARK: - TomTomOfflineMapView

struct TomTomOfflineMapView {
    var mapView: MapView!
    var contentInsets: Binding<EdgeInsets>
    var offlineNavigationController: OfflineNavigationController

    func updateEdgeInsets(context: Context) {
        context.coordinator.setContentInsets(edgeInsets: contentInsets.wrappedValue)
    }

    init(contentInsets: Binding<EdgeInsets>, offlineNavigationController: OfflineNavigationController) {
        self.contentInsets = contentInsets
        self.offlineNavigationController = offlineNavigationController

        // These paths are required for the offline map configuration
        guard let updateStoragePath = OfflineMapPath.updateStoragePath,
              let persistantStoragePath = OfflineMapPath.persistantStoragePath,
              let updateServerURL = URL(string: OfflineMapConfig.ndsUpdateServer),
              let mapDataPath = OfflineMapPath.mapDataPath,
              let keystorePath = OfflineMapPath.keystorePath
        else {
            /* YOUR CODE GOES HERE */
            fatalError("Error!")
        }

        // In the following code, an `NDSStoreUpdateConfig` object will be created that includes configuration, such as relevant region updates.
        // Additionally, the empty map folders were copied by calling "OfflineMapHelper.copyFolders()" in the "OfflineNavigationView.swift" file.
        // Enabling relevant region updates will allow the "NDSStore" object to automatically update the map by downloading relevant data.
        let updateConfig = NDSStoreUpdateConfig(
            updateStoragePath: updateStoragePath,
            persistentStoragePath: persistantStoragePath,
            updateServerURL: updateServerURL,
            updateServerAPIKey: Keys.apiKey,
            iqMapsAllRegionsEnabled: false,
            iqMapsRelevantRegionsEnabled: true,
            iqMapsRelevantRegionsRadius: .tt.kilometers(10),
            iqMapsRelevantRegionsUpdateInterval: .tt.minutes(60),
            iqMapsRegionsAlongRouteEnabled: true,
            iqMapsRegionsAlongRouteRadius: .tt.kilometers(5)
        )

        // Create the "NDSStore" object by the given configurations
        guard let ndsStore = NDSStore(
            mapDataPath: mapDataPath,
            keystorePath: keystorePath,
            accessPermit: .mapLicense(Keys.mapLicense),
            ndsStoreUpdateConfig: updateConfig
        ) else {
            /* YOUR CODE GOES HERE */
            // Check your map license and API key
            fatalError("Error!")
        }

        // It is important to note that the relevant region updates have been enabled above through the use of the "NDSStoreUpdateConfig" configuration.
        // Enabling updates and setting the position of the "NDSStore" object will automatically update the relevant regions of the position.
        // As a result, in the case below, after a certain amount of time (depending on internet connection) the Amsterdam region will be downloaded and displayed on the map.
        // Once downloaded, the following lines can be removed and the app can be rerun. The previously downloaded regions will still be available on the device.
        // Additionally, downloading for any other coordinate can also be attempted.
        ndsStore.updatesEnabled = true
        ndsStore.updatePosition(CLLocationCoordinate2D(
            latitude: Region.amsterdam.lat,
            longitude: Region.amsterdam.lon
        ))

        // Create an offline data provider
        var dataProviders: [MapDisplayDataProvider] = []
        if let offlineDataProvider = OfflineTileDataProviderFactory.createOfflineTileDataProvider(store: ndsStore) {
            dataProviders.append(offlineDataProvider)
        } else {
            /* YOUR CODE GOES HERE */
            fatalError("Error!")
        }

        // Create the map options by creted data provider and other configurations
        let mapOptions = MapOptions(
            apiKey: Keys.apiKey,
            cachePolicy: .noCaching,
            styleMode: .main,
            dataProviders: dataProviders
        )

        // Create the "MapView" object with the map options
        mapView = TomTomSDKMapDisplay.MapView(mapOptions: mapOptions)
    }
}

// MARK: UIViewRepresentable

/// Conforming to the UIViewRepresentable protocol allows you to use the MapView in SwiftUI
extension TomTomOfflineMapView: UIViewRepresentable {
    typealias UIViewType = TomTomSDKMapDisplay.MapView

    func makeUIView(context: Context) -> TomTomSDKMapDisplay.MapView {
        mapView.delegate = context.coordinator
        mapView.currentLocationButtonVisibilityPolicy = .hiddenWhenCentered
        mapView.compassButtonVisibilityPolicy = .visibleWhenNeeded
        return mapView
    }

    func updateUIView(_: TomTomSDKMapDisplay.MapView, context: Context) {
        updateEdgeInsets(context: context)
    }

    func makeCoordinator() -> OfflineMapCoordinator {
        OfflineMapCoordinator(mapView, offlineNavigationController: offlineNavigationController)
    }
}

// MARK: - OfflineMapCoordinator

/// Facilitates communication from the UIView to the SwiftUI environments for the offline map.
final class OfflineMapCoordinator: NSObject {
    // MARK: Lifecycle

    init(_ mapView: TomTomSDKMapDisplay.MapView, offlineNavigationController: OfflineNavigationController) {
        self.offlineNavigationController = offlineNavigationController
        self.mapView = mapView
        super.init()
        observe(offlineNavigationController: offlineNavigationController)
    }

    // MARK: Internal

    func setContentInsets(edgeInsets: EdgeInsets) {
        mapView.contentInsets = NSDirectionalEdgeInsets(
            top: edgeInsets.top,
            leading: edgeInsets.leading,
            bottom: edgeInsets.bottom,
            trailing: edgeInsets.trailing
        )
    }

    // MARK: Private

    private let offlineNavigationController: OfflineNavigationController
    private let mapView: TomTomSDKMapDisplay.MapView
    private var map: TomTomSDKMapDisplay.TomTomMap?
    private var routeOnMap: TomTomSDKMapDisplay.Route?
    private var cameraUpdated = false
    private var cancellableBag = Set<AnyCancellable>()
}

// MARK: TomTomSDKMapDisplay.MapViewDelegate

/// The `mapView(_:, onMapReady:)` callback notifies `OfflineMapCoordinator` that the `TomTomMap` is ready to display.
/// The `TomTomMap` instance can be configured in this callback function.
///
/// You can experiment with different ways of showing the current location on the map by changing the `.locationIndicatorType` in the `mapView(_:, onMapReady:)` callback.
/// Activate the location provider to see the current GPS position on the map.
extension OfflineMapCoordinator: TomTomSDKMapDisplay.MapViewDelegate {
    func mapView(_: MapView, onMapReady map: TomTomMap) {
        // Store the map to be used later
        self.map = map

        // Observe TomTom map actions
        map.delegate = self
        // Observe location engine updates
        map.locationProvider.addObserver(self)
        // Hide the traffic on the map
        map.hideTraffic()
        // Display a chevron at the current location
        map.locationIndicatorType = .navigationChevron(scale: 1)
        // Activate the GPS location engine in TomTomSDK.
        map.activateLocationProvider()
        // Configure the camera to centre on the current location
        map.applyCamera(defaultCameraUpdate)
    }

    func mapView(_: MapView, onLoadFailed error: Error) {
        print("Error occured loading the map \(error.localizedDescription)")
    }

    func mapView(_: MapView, onStyleLoad _: Result<StyleContainer, Error>) {
        print("The map style is loaded")
    }
}

// MARK: Camera Options

/// Defines camera utility functions.
/// The virtual map is observed through a camera that can be zoomed, panned, rotated, and tilted to provide a compelling 3D navigation experience.
extension OfflineMapCoordinator {
    private var defaultCameraUpdate: CameraUpdate {
        let defaultLocation = CLLocation(latitude: 0.0, longitude: 0.0)
        return CameraUpdate(
            position: defaultLocation.coordinate,
            zoom: 1.0,
            tilt: 0.0,
            rotation: 0.0,
            positionMarkerVerticalOffset: 0.0
        )
    }

    func animateCamera(zoom: Double, position: CLLocationCoordinate2D, animationDurationInSeconds: TimeInterval, onceOnly: Bool) {
        if onceOnly, cameraUpdated {
            return
        }
        cameraUpdated = true
        var cameraUpdate = defaultCameraUpdate
        cameraUpdate.zoom = zoom
        cameraUpdate.position = position
        map?.applyCamera(cameraUpdate, animationDuration: animationDurationInSeconds)
    }

    func setCamera(trackingMode: TomTomSDKMapDisplay.CameraTrackingMode) {
        map?.cameraTrackingMode = trackingMode

        // Update chevron position on the screen so it is not hidden behind the navigation panel
        if trackingMode == .followRoute || trackingMode == .follow {
            let cameraUpdate = CameraUpdate(positionMarkerVerticalOffset: 0.4)
            moveCamera(cameraUpdate: cameraUpdate)
        }
    }

    func moveCamera(cameraUpdate: CameraUpdate) {
        map?.moveCamera(cameraUpdate)
    }
}

// MARK: TomTomSDKLocationProvider.LocationProviderObservable

/// Conforming to LocationProviderObservable enables the `OfflineMapCoordinator` to observe GPS updates and authorization changes.
/// This means that when the application starts, the camera position and zoom level are updated in the onLocationUpdated callback function.
/// The user then sees the current location.
extension OfflineMapCoordinator: TomTomSDKLocationProvider.LocationProviderObservable {
    func onLocationUpdated(location: GeoLocation) {
        // Zoom and center the camera on the first location received.
        animateCamera(zoom: 9.0, position: location.location.coordinate, animationDurationInSeconds: 1.5, onceOnly: true)
    }

    func onHeadingUpdate(newHeading _: CLHeading, lastLocation _: GeoLocation) {
        // Handle heading updates
    }

    func onAuthorizationStatusChanged(isGranted _: Bool) {
        // Handle authorization changes
    }
}

// MARK: TomTomSDKMapDisplay.MapDelegate

/// Update the OfflineMapCoordinator to plan a route and add it to the map after a long press.
extension OfflineMapCoordinator: TomTomSDKMapDisplay.MapDelegate {
    func map(_: TomTomMap, onInteraction interaction: MapInteraction) {
        switch interaction {
        case let .longPressed(coordinate):
            offlineNavigationController.navigateToCoordinate(coordinate)
        default:
            // Handle other gestures
            break
        }
    }

    func map(_: TomTomMap, onCameraEvent event: CameraEvent) {
        switch event {
        case let .trackingModeChanged(mode):
            // Handle camera tracking mode change
            break
        default:
            break
        }
    }
}

/// Utilities to plan a route, start location simulation, and start the navigation process.
///
/// The call to the async `planRoute()` function is wrapped in a `Task` so that it can be called from the `navigateToCoordinate` function, even though that function is not async.
/// - Important: Do not use `Navigation` directly to start navigation along the route when using `NavigationView`.
/// Instead, use its `NavigationView.ViewModel` for that. It will also handle both the visual and voice instructions.
extension OfflineNavigationController {
    func navigateToCoordinate(_ destination: CLLocationCoordinate2D) {
        Task { @MainActor in
            do {
                // Plan the route and add it to the map
                let start = try startCoordinate()
                let routePlan = try await planRoute(from: start, to: destination)

                stopNavigating()

                let route = routePlan.route
                self.displayedRouteSubject.send(route)

                let navigationOptions = NavigationOptions(activeRoutePlan: routePlan)
                self.navigationViewModel.start(navigationOptions)

                // Start navigation after a short delay so that we can clearly see the transition to the driving view
                try await Task.sleep(nanoseconds: UInt64(1.0 * 1_000_000_000))

                // Use simulated location updates
                self.simulatedLocationProvider.updateCoordinates(route.geometry, interpolate: true)
                self.simulatedLocationProvider.start()
                self.mapMatchedLocationProvider.send(navigation.mapMatchedLocationProvider)

                self.showNavigationView = true
            } catch {
                print("Error when planning a route: \(error)")
            }
        }
    }

    func stopNavigating() {
        displayedRouteSubject.send(nil)
        navigationViewModel.stop()
        simulatedLocationProvider.stop()
        showNavigationView = false
    }
}

// MARK: - Route planning

/// Utilities for route planning.
extension OfflineNavigationController {
    enum RoutePlanError: Error {
        case unknownStartingLocation
        case unableToPlanRoute(_ description: String = "")
    }

    private func startCoordinate() throws -> CLLocationCoordinate2D {
        if let simulatedPosition = simulatedLocationProvider.location?.location.coordinate {
            return simulatedPosition
        }
        if let currentPosition = locationProvider.location?.location.coordinate {
            return currentPosition
        }
        throw RoutePlanError.unknownStartingLocation
    }

    private func createRoutePlanningOptions(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D
    )
        throws -> TomTomSDKRoutePlanner.RoutePlanningOptions
    {
        let itinerary = Itinerary(
            origin: ItineraryPoint(coordinate: origin),
            destination: ItineraryPoint(coordinate: destination)
        )
        let costModel = CostModel(routeType: .fast)

        // Use language code from Supported languages list:
        // https://developer.tomtom.com/routing-api/documentation/routing/calculate-route#supported-languages
        // For voice announcements:
        let languageCode = Locale.preferredLanguages.first ?? Locale.current.languageCode ?? "en-GB"
        let locale = Locale(identifier: languageCode)
        let guidanceOptions = try GuidanceOptions(
            instructionType: .tagged,
            language: locale,
            roadShieldReferences: .all,
            announcementPoints: .all,
            phoneticsType: .IPA
        )

        let options = try RoutePlanningOptions(
            itinerary: itinerary,
            costModel: costModel,
            guidanceOptions: guidanceOptions
        )
        return options
    }

    private func planRoute(
        from origin: CLLocationCoordinate2D,
        to destination: CLLocationCoordinate2D
    ) async throws
        -> TomTomSDKNavigationEngines.RoutePlan
    {
        let routePlanningOptions = try createRoutePlanningOptions(from: origin, to: destination)
        let route = try await planRoute(withRoutePlanner: routePlanner, routePlanningOptions: routePlanningOptions)
        return TomTomSDKNavigationEngines.RoutePlan(route: route, routingOptions: routePlanningOptions)
    }

    private func planRoute(
        withRoutePlanner routePlanner: OnlineRoutePlanner,
        routePlanningOptions: RoutePlanningOptions
    ) async throws
        -> TomTomSDKRoute.Route
    {
        return try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<TomTomSDKRoute.Route, Error>) in
            routePlanner.planRoute(options: routePlanningOptions, onRouteReady: nil) { result in
                switch result {
                case let .failure(error):
                    if let routingError = error as? RoutingError {
                        print("Error code: \(routingError.code)")
                        print("Error message: \(String(describing: routingError.errorDescription))")
                        continuation.resume(throwing: routingError)
                        return
                    }
                    continuation.resume(throwing: error)
                case let .success(response):
                    guard let routes = response.routes else {
                        continuation.resume(throwing: RoutePlanError.unableToPlanRoute())
                        return
                    }
                    guard let route = routes.first else {
                        continuation.resume(throwing: RoutePlanError.unableToPlanRoute())
                        return
                    }
                    continuation.resume(returning: route)
                }
            }
        }
    }
}

/// Utility to observe `OfflineNavigationController`. It helps to display changes to the current route and its progress on the map.
///
/// After adding a route on the map, you will receive a reference to that route.
/// The `addRouteToMap` function keeps it in the `routeOnMap` so that it can show the visual progress along the route, without being added again.
/// The default location provider has an approximate position but no route information.
/// For smooth movement of the chevron along the route, ensure the map uses a `mapMatchedLocationProvider` from `Navigation` instead of the `SimulatedLocationProvider`.
extension OfflineMapCoordinator {
    func observe(offlineNavigationController: OfflineNavigationController) {
        offlineNavigationController.displayedRouteSubject.sink { [weak self] route in
            guard let self = self else { return }
            self.map?.removeRoutes()
            if let route = route {
                self.addRouteToMap(route: route)
                self.setCamera(trackingMode: .followRoute)
            } else {
                self.routeOnMap = nil
                self.setCamera(trackingMode: .follow)
            }
        }.store(in: &cancellableBag)

        offlineNavigationController.progressOnRouteSubject.sink { [weak self] progress in
            self?.routeOnMap?.progressOnRoute = progress
        }.store(in: &cancellableBag)

        offlineNavigationController.mapMatchedLocationProvider.sink { [weak self] locationProvider in
            self?.map?.locationProvider = locationProvider
        }.store(in: &cancellableBag)
    }
}

/// Utilities to add the planned route to the map.
extension OfflineMapCoordinator {
    private func createMapRouteOptions(coordinates: [CLLocationCoordinate2D]) -> TomTomSDKMapDisplay.RouteOptions {
        var routeOptions = RouteOptions(coordinates: coordinates)
        routeOptions.outlineWidth = 1
        routeOptions.routeWidth = 5
        routeOptions.color = .activeRoute
        return routeOptions
    }

    func addRouteToMap(route: TomTomSDKRoute.Route) {
        // Create the route options from the route geometry and add it to the map
        let routeOptions = createMapRouteOptions(coordinates: route.geometry)
        if let routeOnMap = try? map?.addRoute(routeOptions) {
            self.routeOnMap = routeOnMap

            // Zoom the map to make the route visible
            map?.zoomToRoutes(padding: 32)
        }
    }
}

// MARK: - NavigationView Actions

/// Utilities to handle actions like arrival, mute, etc
extension OfflineNavigationController {
    func onNavigationViewAction(_ action: TomTomSDKNavigationUI.NavigationView.Action) {
        switch action {
        case let .arrival(action):
            onArrivalAction(action)
        case let .instruction(action):
            onInstructionAction(action)
        case let .confirmation(action):
            onConfirmationAction(action)
        case let .error(action):
            onErrorAction(action)
        @unknown default:
            /* YOUR CODE GOES HERE */
            break
        }
    }

    private func onArrivalAction(_ action: TomTomSDKNavigationUI.NavigationView.ArrivalAction) {
        switch action {
        case .close:
            stopNavigating()
        @unknown default:
            /* YOUR CODE GOES HERE */
            break
        }
    }

    private func onInstructionAction(_ action: TomTomSDKNavigationUI.NavigationView.InstructionAction) {
        switch action {
        case let .tapSound(muted):
            navigationViewModel.muteTextToSpeech(mute: !muted)
        case .tapLanes:
            navigationViewModel.hideLanes()
        case .tapThen:
            navigationViewModel.hideCombinedInstruction()
        @unknown default:
            /* YOUR CODE GOES HERE */
            break
        }
    }

    private func onConfirmationAction(_ action: TomTomSDKNavigationUI.NavigationView.ConfirmationAction) {
        switch action {
        case .yes:
            stopNavigating()
        case .no:
            /* YOUR CODE GOES HERE */
            break
        @unknown default:
            /* YOUR CODE GOES HERE */
            break
        }
    }

    private func onErrorAction(_: TomTomSDKNavigationUI.NavigationView.ErrorAction) {
        /* YOUR CODE GOES HERE */
    }
}
