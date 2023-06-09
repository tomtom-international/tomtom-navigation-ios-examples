//  © 2023 TomTom NV. All rights reserved.
//
//  This software is the proprietary copyright of TomTom NV and its subsidiaries and may be
//  used for internal evaluation purposes or commercial use strictly subject to separate
//  license agreement between you and TomTom NV. If you are the licensee, you are only permitted
//  to use this software in accordance with the terms of your license agreement. If you are
//  not the licensee, you are not authorized to use this software in any manner and should
//  immediately return or destroy it.

import SwiftUI

// MARK: - Main Menu

struct MainMenu: View {
    var body: some View {
        NavigationView {
            VStack {
                ScrollView(showsIndicators: false) {
                    Group {
                        Text(Resource.Strings.title)
                            .font(.title)
                            .fontWeight(.semibold)
                            .foregroundColor(Resource.Colors.secondaryContent)

                        VStack(alignment: .center, spacing: 20) {
                            // MARK: Basic Driving App

                            NavigationLink {
                                NavigationMenu()
                            } label: {
                                MainMenuRow(
                                    title: Resource.Strings.basicDrivingApp,
                                    icon: Resource.Images.phoneApp,
                                    active: true
                                )
                            }

                            Divider()
                                .overlay(Resource.Colors.inputFieldLight)
                                .padding(.vertical, 10)

                            // MARK: Map Examples

                            NavigationLink {
                                MapExamplesView()
                            } label: {
                                MainMenuRow(
                                    title: Resource.Strings.map,
                                    icon: Resource.Images.map
                                )
                            }

                            // MARK: Navigation Examples

                            NavigationLink {
                                SearchExamplesView()
                            } label: {
                                MainMenuRow(
                                    title: Resource.Strings.search,
                                    icon: Resource.Images.search
                                )
                            }

                            // MARK: Routing Examples

                            NavigationLink {
                                RoutingExamplesView()
                            } label: {
                                MainMenuRow(
                                    title: Resource.Strings.routing,
                                    icon: Resource.Images.route
                                )
                            }

                            // MARK: Navigation Examples

                            NavigationLink {
                                NavigationExamplesView()
                            } label: {
                                MainMenuRow(
                                    title: Resource.Strings.navigation,
                                    icon: Resource.Images.car
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top, 60)
                }

                // MARK: Logo

                Image(Resource.Images.logo)
                    .foregroundColor(Resource.Colors.bodyLight)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// MARK: - Preview

struct MainMenu_Previews: PreviewProvider {
    static var previews: some View {
        MainMenu()
            .previewDevice("iPhone 14")

        MainMenu()
            .previewDevice("iPad Pro")
    }
}

// MARK: - Main Menu Button View

struct MainMenuRow: View {
    var title: String
    var icon: String
    var active: Bool = false

    var body: some View {
        HStack {
            Image(icon)
                .foregroundColor(active ? Resource.Colors.primaryContent : Resource.Colors.primaryLight)

            Text(title)
                .font(.body)
                .fontWeight(.bold)
                .foregroundColor(active ? Resource.Colors.primaryContent : Resource.Colors.secondaryContent)
            Spacer()
        }
        .frame(minWidth: 0, maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(active ? Resource.Colors.primaryLight : Resource.Colors.primaryContent)
                .shadow(color: Resource.Colors.boxShadow, radius: 8, x: 0, y: 0)
        )
    }
}

// MARK: - Preview

struct MainMenuRow_Previews: PreviewProvider {
    static var previews: some View {
        MainMenuRow(title: Resource.Strings.map, icon: Resource.Images.map)
            .previewDevice("iPhone 14")

        MainMenuRow(title: Resource.Strings.map, icon: Resource.Images.map)
            .previewDevice("iPad Pro")
    }
}
