//  © 2023 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

import Foundation
import SwiftUI

enum Resource {
    enum Strings {
        static let title = NSLocalizedString("main_menu", comment: "")
        static let basicDrivingApp = NSLocalizedString("basic_driving_app", comment: "")
        static let mapDisplay = NSLocalizedString("map_display", comment: "")
        static let search = NSLocalizedString("search", comment: "")
        static let routing = NSLocalizedString("routing", comment: "")
        static let navigation = NSLocalizedString("navigation", comment: "")
        static let mapDemoTitle = NSLocalizedString("map_demo_title", comment: "")
        static let navigationDemoTitle = NSLocalizedString("navigation_demo_title", comment: "")
        static let routingDemoTitle = NSLocalizedString("routing_demo_title", comment: "")
        static let searchDemoTitle = NSLocalizedString("search_demo_title", comment: "")
        static let hybridNavigationDemoTitle = NSLocalizedString("hybrid_navigation_demo_title", comment: "")
        static let options = NSLocalizedString("options", comment: "")
        static let mapMode = NSLocalizedString("map_mode", comment: "")
        static let online = NSLocalizedString("online", comment: "")
        static let offline = NSLocalizedString("offline", comment: "")
        static let hybrid = NSLocalizedString("hybrid", comment: "")
        static let next = NSLocalizedString("next", comment: "")
        static let downloading = NSLocalizedString("downloading", comment: "")
        static let map = NSLocalizedString("map", comment: "")
    }

    enum Colors {
        static let bodyLight = Color("tt_colour_body_light")
        static let boxShadow = Color("tt_colour_box_shadow")
        static let inputFieldLight = Color("tt_colour_input_field_light")
        static let primaryLight = Color("tt_colour_primary_light")
        static let primaryContent = Color("tt_colour_primary_content_light")
        static let secondaryContent = Color("tt_colour_secondary_content_light")
        static let titleLight = Color("tt_colour_title_light")
        static let inactiveLight = Color("tt_colour_inactive_light")
    }

    enum Images {
        static let back = "ic_back"
        static let car = "ic_car"
        static let logo = "gr_logo_white"
        static let map = "ic_map"
        static let phoneApp = "ic_phone_app"
        static let route = "ic_route"
        static let search = "ic_search"
        static let online = "ic_online"
        static let hybrid = "ic_hybrid"
        static let offline = "ic_offline"
    }
}
