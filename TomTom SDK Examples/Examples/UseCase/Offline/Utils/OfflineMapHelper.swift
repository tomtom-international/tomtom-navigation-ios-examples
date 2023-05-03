//  © 2023 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

import Foundation

// MARK: Offline Map Helper

enum OfflineMapHelper {
    // MARK: Offline Map Errors

    enum OfflineMapError: LocalizedError {
        case bundleResourceURLNotExist
        case documentsDirectoryNotExist
        case mapFolderDoesNotExist
        case keystoreFileDoesNotExist

        public var errorDescription: String? {
            /* YOUR CODE GOES HERE */
            return "Error! . \(self)"
        }
    }

    // MARK: Copy Folders

    /// Copy the 'Map' folder (all folders and files recursively inside) from the Bundle to the device
    static func copyFolders(completion: (_ success: Bool, _ error: Error?) -> Void) {
        let fileManager = FileManager.default

        guard let pathFromBundle = Bundle.main.resourceURL?.appendingPathComponent(OfflineConfig.mapFolderName).path else {
            completion(false, OfflineMapError.bundleResourceURLNotExist)
            return
        }

        guard let docsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            completion(false, OfflineMapError.documentsDirectoryNotExist)
            return
        }
        let pathDestDocs = docsURL.appendingPathComponent(OfflineConfig.mapFolderName).path

        if fileManager.fileExists(atPath: pathDestDocs) {
            // The path exists. That means the files have already been copied previously.
            completion(true, nil)
        } else {
            // Copy directory content recursively
            do {
                let files = try fileManager.contentsOfDirectory(atPath: pathFromBundle)
                try fileManager.copyItem(atPath: pathFromBundle, toPath: pathDestDocs)

                for fileName in files {
                    try fileManager.copyItem(atPath: "\(pathFromBundle)/\(fileName)", toPath: "\(pathDestDocs)/\(fileName)")
                }

                if OfflineMapPath.mapDataPath == nil {
                    completion(false, OfflineMapError.mapFolderDoesNotExist)
                    return
                }

                if OfflineMapPath.keystorePath == nil {
                    completion(false, OfflineMapError.keystoreFileDoesNotExist)
                    return
                }

                completion(true, nil)
            } catch {
                completion(false, error)
            }
        }
    }
}

// MARK: Offline Map Paths

enum OfflineMapPath {
    // MARK: Internal

    // Properties to access offline map resources
    static var mapDataPath: String? {
        if let documentDirectory {
            let resourcesMapPath = documentDirectory.path + OfflineConfig.mapDataPath
            return pathContainsMap(resourcesMapPath) ? resourcesMapPath : nil
        } else {
            return nil
        }
    }
    
    static var keystorePath: String? {
        if let documentDirectory {
            let resourcesKeystorePath = documentDirectory.path + OfflineConfig.keystorePath
            return pathExists(resourcesKeystorePath) ? resourcesKeystorePath : nil
        } else {
            return nil
        }
    }
    
    static var updateStoragePath: String? {
        if let documentDirectory {
            let updateStoragePath = documentDirectory.path + OfflineConfig.updateStoragePath
            return updateStoragePath
        } else {
            return nil
        }
    }
    
    static var persistantStoragePath: String? {
        if let documentDirectory {
            let persistantStoragePath = documentDirectory.path + OfflineConfig.persistantStoragePath
            return persistantStoragePath
        } else {
            return nil
        }
    }

    // MARK: Private

    private static let documentDirectory: URL? = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
    
    private static func pathContainsMap(_ path: String) -> Bool { pathExists(path + "/ROOT.NDS") }

    private static func pathExists(_ path: String) -> Bool {
        let fileManager = FileManager.default
        return fileManager.fileExists(atPath: path)
    }
}
