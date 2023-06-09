//  © 2023 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

import SwiftUI

struct NavigationMenu: View {
    var body: some View {
        ZStack(alignment: .topLeading, content: {
            VStack(alignment: .center, spacing: Constants.verticalSpacing) {
                Text(Resource.Strings.options)
                    .foregroundColor(Resource.Colors.titleLight)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.vertical, 20)

                HStack(alignment: .center, spacing: Constants.verticalSpacing) {
                    horizontalLine

                    Text(Resource.Strings.mapMode)
                        .fontWeight(.semibold)
                        .foregroundColor(Resource.Colors.bodyLight)

                    horizontalLine
                }

                HStack {
                    // Online
                    VStack(alignment: .center, spacing: Constants.verticalSpacing) {
                        Image(Resource.Images.online)
                            .modifier(MenuModifier(isSelected: selectedMapMode == .online))

                        Text(Resource.Strings.online)
                            .foregroundColor(Resource.Colors.bodyLight)
                    }
                    .onTapGesture {
                        selectedMapMode = .online
                    }

                    // Hybrid
                    VStack(alignment: .center, spacing: Constants.verticalSpacing) {
                        Image(Resource.Images.hybrid)
                            .modifier(MenuModifier(isSelected: selectedMapMode == .hybrid))

                        Text(Resource.Strings.hybrid)
                            .foregroundColor(Resource.Colors.bodyLight)
                    }
                    .onTapGesture {
                        selectedMapMode = .hybrid
                    }

                    // Offline
                    VStack(alignment: .center, spacing: Constants.verticalSpacing) {
                        Image(Resource.Images.offline)
                            .modifier(MenuModifier(isSelected: selectedMapMode == .offline))

                        Text(Resource.Strings.offline)
                            .foregroundColor(Resource.Colors.bodyLight)
                    }
                    .onTapGesture {
                        selectedMapMode = .offline
                    }
                }

                Spacer()

                Button {
                    showNavigationExamplesSheet = true
                } label: {
                    Text(Resource.Strings.next)
                        .font(.body)
                        .fontWeight(.bold)
                        .foregroundColor(Resource.Colors.primaryContent)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(
                            Capsule()
                                .fill(selectedMapMode == .none ? Resource.Colors.inactiveLight : Resource.Colors.primaryLight)
                                .shadow(color: Resource.Colors.boxShadow, radius: 8, x: 0, y: 0)
                        )
                }
                .disabled(selectedMapMode == nil)
                .fullScreenCover(isPresented: $showNavigationExamplesSheet) {
                    navigationContent
                }
            }
            .padding()

            // MARK: Back Button

            BackButton(useShadow: false, presentationMode: presentationMode)
                .padding(.vertical)
        })
        .navigationBarHidden(true)
    }

    // MARK: - Internal
    
    enum Constants {
        static let verticalSpacing = 16.0
        static let lineHeight = 1.0
    }

    enum MapMode {
        case online
        case hybrid
        case offline
    }

    @Environment(\.presentationMode)
    var presentationMode

    @State
    var selectedMapMode: MapMode?

    @State
    var showNavigationExamplesSheet: Bool = false

    @ViewBuilder
    var navigationContent: some View {
        switch selectedMapMode {
        case .online:
            OnlineNavigationView()
        case .hybrid:
            HybridNavigationView()
        case .offline:
            OfflineNavigationView()
        case .none:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var horizontalLine: some View {
        Rectangle().frame(height: Constants.lineHeight)
            .foregroundColor(Resource.Colors.inputFieldLight)
    }
}

// MARK: - Preview

struct NavigationMenu_Previews: PreviewProvider {
    static var previews: some View {
        NavigationMenu()
            .previewDevice("iPhone 14")

        NavigationMenu()
            .previewDevice("iPhone SE (3rd generation)")

        NavigationMenu()
            .previewDevice("iPad Pro")
    }
}

// MARK: - Modifiers

private struct MenuModifier: ViewModifier {
    var isSelected: Bool

    func body(content: Content) -> some View {
        content
            .padding(22)
            .background(
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Resource.Colors.primaryContent)
                        .shadow(color: Resource.Colors.boxShadow, radius: 8, x: 0, y: 0)
                    if isSelected {
                        RoundedRectangle(cornerRadius: 16)
                            .stroke(Resource.Colors.primaryLight, lineWidth: 4)
                    }
                }
            )
    }
}
