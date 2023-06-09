//  © 2023 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

import SwiftUI

struct BackButton: View {
    var width: CGFloat = 64
    var height: CGFloat = 64
    var useShadow: Bool = false
    var presentationMode: Binding<PresentationMode>

    var body: some View {
        Button {
            presentationMode.wrappedValue.dismiss()
        } label: {
            Image(Resource.Images.back)
                .foregroundColor(Resource.Colors.secondaryContent)
                .frame(width: width, height: height)
                .background(
                    Circle()
                        .foregroundColor(Resource.Colors.primaryContent)
                        .shadow(color: useShadow ? Resource.Colors.boxShadow : .clear, radius: 8, x: 0, y: 0)
                )
        }
    }
}

struct BackButton_Previews: PreviewProvider {
    @Environment(\.presentationMode) static var presentationMode

    static var previews: some View {
        BackButton(presentationMode: presentationMode)
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
