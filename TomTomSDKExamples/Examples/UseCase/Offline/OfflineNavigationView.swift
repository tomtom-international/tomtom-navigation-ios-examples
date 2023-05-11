//  © 2023 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

import SwiftUI

// MARK: - Basic Driving App Offline Mode

struct OfflineNavigationView: View {
    @Environment(\.presentationMode)
    var presentationMode

    var copyFoldersStatus: Bool = false
    var copyFoldersError: Error?

    init() {
        // Copy the offline map folders into the simulator/device
        OfflineMapHelper.copyFolders { success, error in
            copyFoldersStatus = success
            copyFoldersError = error
        }
    }

    var body: some View {
        ZStack(alignment: .topLeading, content: {
            if copyFoldersStatus {
                // MARK: Navigation SDK

                OfflineNavigationContent()
            } else {
                Text(copyFoldersError?.localizedDescription ?? "-")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }

            // MARK: Back Button

            BackButton(presentationMode: presentationMode)
                .padding()
        })
        .navigationBarHidden(true)
    }
}

// MARK: - Preview

struct OfflineNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        OfflineNavigationView()
            .previewDevice("iPhone 14")

        OfflineNavigationView()
            .previewDevice("iPad Pro")
    }
}
