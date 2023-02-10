//
// LocationsViewModel.swift
// SwiftfulMapApp
//
// Created by Ahmed Ali
//

import Foundation
import MapKit
import SwiftUI

class LocationsViewModel: ObservableObject {
    @Published private(set) var locations: [Location]
    @Published private(set) var mapLocation: Location {
        didSet {
            updateMapRegion(for: mapLocation)
        }
    }
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    @Published private(set) var showLocationsList = false
    
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    
    @Published var sheetLocation: Location?
    
    init() {
        let storedLocation = LocationsDataService.locations
        locations = storedLocation
        mapLocation = storedLocation.first!
        
        updateMapRegion(for: mapLocation)
    }
    
    private func updateMapRegion(for location: Location) {
        withAnimation(.easeInOut) {
            mapRegion = MKCoordinateRegion(
                center: location.coordinates,
                span: mapSpan
            )
        }
    }
    
    func toggleLocationList() {
        withAnimation(.easeInOut) {
            showLocationsList.toggle()
        }
    }
    
    func updateMapLocation(location: Location) {
        withAnimation(.easeInOut) {
            mapLocation = location
            showLocationsList = false
        }
    }
    
    func nextBtnPressed() {
        guard let currentIndex = locations.firstIndex(where: { $0 == mapLocation }) else { return }
        let nextIndex = currentIndex + 1
        guard locations.indices.contains(nextIndex) else {
            updateMapLocation(location: locations.first!)
            return
        }
        updateMapLocation(location: locations[nextIndex])
    }
}
