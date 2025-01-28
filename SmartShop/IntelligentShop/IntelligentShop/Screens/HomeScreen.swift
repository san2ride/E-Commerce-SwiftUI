//
//  HomeScreen.swift
//  IntelligentShop
//
//  Created by Jason Sanchez on 1/28/25.
//

import SwiftUI

enum AppScreen: Hashable, Identifiable, CaseIterable {
    case home
    case myProducts
    case cart
    case profile
    
    var id: AppScreen { self }
}

extension AppScreen {
    @ViewBuilder
    var label: some View {
        switch self {
            case .home:
                Label("Home", systemImage: "heart")
            case .myProducts:
                Label("", systemImage: "star")
            case .cart:
                Label("Cart", systemImage: "cart")
            case .profile:
                Label("Profile", systemImage: "person.fill")
        }
    }
    var destination: some View {
        switch self {
            case .home:
                Text("Home")
            case .myProducts:
                Text("My Products")
            case .cart:
                Text("Cart")
            case .profile:
                Text("Profile")
        }
    }
}

struct HomeScreen: View {
    @State var selection: AppScreen?
    
    var body: some View {
        TabView(selection: $selection) {
            ForEach(AppScreen.allCases) { screen in
                screen.label
                    .tag(screen as AppScreen?)
                    .tabItem { screen.label }
            }
        }
    }
}

#Preview {
    HomeScreen()
}
