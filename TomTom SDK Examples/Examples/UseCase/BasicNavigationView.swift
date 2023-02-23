//  © 2023 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

import SwiftUI

// MARK: - Basic Driving App

struct BasicNavigationView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        ZStack(alignment: .topLeading, content: {
            NavigationView {
                // MARK: Navigation SDK

                BasicNavigationContent()
            }
            .navigationBarHidden(true)

            // MARK: Back Button

            BackButton(presentationMode: presentationMode)
                .padding()
        })
    }
}

// MARK: - Preview

struct BasicNavigationView_Previews: PreviewProvider {
    static var previews: some View {
        BasicNavigationView()
            .preferredColorScheme(.dark)
    }
}
