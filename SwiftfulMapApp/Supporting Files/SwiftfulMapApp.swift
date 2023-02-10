//
// Location.swift
// SwiftfulMapApp
//
// Created by Ahmed Ali
//

import SwiftUI

@main
struct SwiftfulMapApp: App {
    @StateObject private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)
        }
    }
}
