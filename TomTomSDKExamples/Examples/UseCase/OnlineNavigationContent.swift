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
import TomTomSDKDefaultTextToSpeech
import TomTomSDKLocationProvider
import TomTomSDKMapDisplay
import TomTomSDKNavigation
import TomTomSDKNavigationEngines
import TomTomSDKNavigationOnline
import TomTomSDKNavigationUI
import TomTomSDKRoute
import TomTomSDKRoutePlanner
import TomTomSDKRoutePlannerOnline
import TomTomSDKRouteReplannerDefault

/// This example shows how to build a simple navigation application using the TomTom Navigation SDK for iOS.
/// The application displays a map and shows the user’s location. After the user selects a destination with a long press, the app plans a route and draws it on the map.
/// Navigation is started automatically using the route simulation.
/// The application will display upcoming maneuvers, remaining distance, estimated time of arrival (ETA), current speed, and speed limit information.
///
/// For more details on this example, check out the tutorial: https://developer.tomtom.com/ios/navigation/documentation/use-cases/build-a-navigation-app
struct OnlineNavigationContent: View {
    var body: some View {
        MainView()
    }
}

// MARK: - NavigationController

/// An observable class to handle flows between modules
final class NavigationController: ObservableObject {
    // MARK: Lifecycle

    convenience init() {
        let textToSpeech = SystemTextToSpeechEngine()
        let routePlanner = TomTomSDKRoutePlannerOnline.OnlineRoutePlanner(apiKey: Keys.apiKey)
        let routeReplanner = RouteReplannerFactory.create(routePlanner: routePlanner, replanningPolicy: .findBetter)
        let locationProvider = DefaultCLLocationProvider()
        let simulatedLocationProvider = SimulatedLocationProvider(delay: .tt.seconds(1))
        let navigationConfiguration = OnlineTomTomNavigationFactory.Configuration(
            locationProvider: simulatedLocationProvider,
            routeReplanner: routeReplanner,
            apiKey: Keys.apiKey,
            betterProposalAcceptanceMode: .automatic
        )        
        guard let navigation = try? OnlineTomTomNavigationFactory.create(configuration: navigationConfiguration) as? Navigation else {
            fatalError("The navigation object could not be created!")
        }
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
extension NavigationController: NavigationProgressObserver {
    func didUpdateProgress(progress: RouteProgress) {
        progressOnRouteSubject.send(progress.distanceAlongRoute)
    }
}

// MARK: NavigationRouteObserver

/// Allows observing route changes.
extension NavigationController: NavigationRouteObserver {
    func didDeviateFromRoute(currentRoute _: TomTomSDKRoute.Route, location _: TomTomSDKLocationProvider.GeoLocation) {}

    func didProposeRoutePlan(routePlan _: TomTomSDKNavigationEngines.RoutePlan, reason _: TomTomSDKNavigationEngines.RouteReplanningReason) {}

    func didReplanRoute(replannedRoute: TomTomSDKRoute.Route, reason _: TomTomSDKNavigationEngines.RouteReplanningReason) {
        displayedRouteSubject.send(replannedRoute)
    }

    func didChangeRoutes(navigatedRoutes _: TomTomSDKNavigation.NavigatedRoutes) {}

    func didReplanRouteOnLanguageChange(replannedRoute _: TomTomSDKRoute.Route, reason _: TomTomSDKNavigationEngines.RouteReplanningReason, language _: Locale) {}
}

// MARK: - MainView

struct MainView: View {
    // MARK: Internal

    var body: some View {
        ZStack(alignment: .bottom) {
            TomTomMapView(contentInsets: $contentInsets, navigationController: navigationController)
            if navigationController.showNavigationView {
                NavigationView(
                    navigationController.navigationViewModel,
                    action: navigationController.onNavigationViewAction
                )
            }
        }
        .onDisappear {
            navigationController.stopNavigating()
        }
    }

    // MARK: Private

    @State
    private var contentInsets = EdgeInsets()

    @StateObject
    var navigationController = NavigationController()
}

// MARK: - TomTomMapView

struct TomTomMapView {
    var mapView = TomTomSDKMapDisplay.MapView()
    var contentInsets: Binding<EdgeInsets>
    var navigationController: NavigationController

    func updateEdgeInsets(context: Context) {
        context.coordinator.setContentInsets(edgeInsets: contentInsets.wrappedValue)
    }
}

// MARK: UIViewRepresentable

/// Extend the TomTomMapView to conform to the UIViewRepresentable protocol.
/// This allows you to use the MapView in SwiftUI
extension TomTomMapView: UIViewRepresentable {
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

    func makeCoordinator() -> MapCoordinator {
        MapCoordinator(mapView, navigationController: navigationController)
    }
}

// MARK: - MapCoordinator

/// Create the MapCoordinator, which facilitates communication from the UIView to the SwiftUI environments.
final class MapCoordinator: NSObject {
    // MARK: Lifecycle

    init(_ mapView: TomTomSDKMapDisplay.MapView, navigationController: NavigationController) {
        self.navigationController = navigationController
        self.mapView = mapView
        super.init()
        observe(navigationController: navigationController)
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

    private let navigationController: NavigationController
    private let mapView: TomTomSDKMapDisplay.MapView
    private var map: TomTomSDKMapDisplay.TomTomMap?
    private var routeOnMap: TomTomSDKMapDisplay.Route?
    private var cameraUpdated = false
    private var cancellableBag = Set<AnyCancellable>()
}

// MARK: TomTomSDKMapDisplay.MapViewDelegate

/// Extend the MapCoordinator to conform to the MapViewDelegate protocol by implementing the onMapReady callback.
/// The onMapReady callback notifies MapCoordinator that the Map is ready to display.
/// The Map instance can be configured in this callback function
///
/// You can experiment with different ways of showing the current location on the map by changing the locationIndicatorType in the onMapReady callback.
/// Activate the location provider to see the current GPS position on the map
extension MapCoordinator: TomTomSDKMapDisplay.MapViewDelegate {
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
        print("Style loaded")
    }
}

// MARK: Camera Options

/// Create the camera utility functions.
/// The virtual map is observed through a camera that can be zoomed, panned, rotated, and tilted to provide a compelling 3D navigation experience.
extension MapCoordinator {
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

/// Extend MapCoordinator to conform to LocationProviderObservable by adding the following functions.
///
/// This extension enables the MapCoordinator to observe GPS updates and authorization changes.
/// This means that when the application starts, the camera position and zoom level are updated in the onLocationUpdated callback function.
/// The user then sees the current location.
extension MapCoordinator: TomTomSDKLocationProvider.LocationProviderObservable {
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

/// Extend MapCoordinator to conform to MapDelegate.
///
/// Update the MapCoordinator to plan a route and add it to the map after a long press.
extension MapCoordinator: TomTomSDKMapDisplay.MapDelegate {
    func map(_: TomTomMap, onInteraction interaction: MapInteraction) {
        switch interaction {
        case let .longPressed(coordinate):
            navigationController.navigateToCoordinate(coordinate)
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

/// Add an extension to NavigationController with a navigateToCoordinate function that plans a route, starts location simulation and starts the navigation process.
///
/// The call to the async planRoute function is wrapped in a Task so that it can be called from the navigateToCoordinate function, even though that function is not async.
/// Do not use Navigation directly to start navigation along the route when using NavigationView.
/// Instead, use its NavigationView.ViewModel for that. It will also handle both the visual and voice instructions.
extension NavigationController {
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

/// Create a NavigationController extension for the route planning functions
extension NavigationController {
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

/// Update the MapCoordinator extension with the observe function to display changes to the current route and its progress on the map.
///
/// After adding a route on the map, you will receive a reference to that route.
/// The addRouteToMap function keeps it in the routeOnMap so that it can show the visual progress along the route, without being added again.
/// The default location provider has an approximate position but no route information.
/// For smooth movement of the chevron along the route, ensure the map uses a mapMatchedLocationProvider from Navigation instead of the SimulatedLocationProvider.
extension MapCoordinator {
    func observe(navigationController: NavigationController) {
        navigationController.displayedRouteSubject.sink { [weak self] route in
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

        navigationController.progressOnRouteSubject.sink { [weak self] progress in
            self?.routeOnMap?.progressOnRoute = progress
        }.store(in: &cancellableBag)

        navigationController.mapMatchedLocationProvider.sink { [weak self] locationProvider in
            self?.map?.locationProvider = locationProvider
        }.store(in: &cancellableBag)
    }
}

/// Create a MapCoordinator extension to add the planned route to the map
extension MapCoordinator {
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

/// Update the NavigationController extension with the onNavigationViewAction function to handle actions like arrival, mute, and etc
extension NavigationController {
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
