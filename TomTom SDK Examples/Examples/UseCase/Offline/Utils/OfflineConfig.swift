//  © 2023 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

import Foundation

enum OfflineConfig {
    // Update Server
    static let ndsUpdateServer = "https://api.tomtom.com/nds-test/updates/1/fetch"

    // Folder paths
    static let mapFolderName = "Map"
    static let mapDataPath = "/Map/DATA"
    static let keystorePath = "/Map/keystore.sqlite"
    static let updateStoragePath = "/update"
    static let persistantStoragePath = "/persistent"
}

enum Region {
    static let amsterdam = (
        lat: 52.36198355889382,
        lon: 4.899839061959026
    )
}
