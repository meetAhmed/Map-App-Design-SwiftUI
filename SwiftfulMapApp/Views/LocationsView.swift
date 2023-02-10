//
// LocationsView.swift
// SwiftfulMapApp
//
// Created by Ahmed Ali
//

import SwiftUI
import MapKit

struct LocationsView: View {
    @EnvironmentObject private var vm: LocationsViewModel
    let maxWidthForIpad: CGFloat = 700
    
    var body: some View {
        ZStack {
            mapView
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                header
                    .padding()
                    .frame(maxWidth: maxWidthForIpad)
                
                Spacer()
                locationPreviewStack
            }
        }
        .sheet(item: $vm.sheetLocation) { location in
            LocationDetailsView(location: location)
        }
    }
}

struct LocationsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationsView()
            .environmentObject(LocationsViewModel())
    }
}

private extension LocationsView {
    var header: some View {
        VStack {
            Button {
                vm.toggleLocationList()
            } label: {
                Text(vm.mapLocation.name + ", " + vm.mapLocation.cityName)
                    .font(.title2)
                    .fontWeight(.black)
                    .foregroundColor(.primary)
                    .frame(height: 55)
                    .frame(maxWidth: .infinity)
                    .animation(.none, value: vm.mapLocation)
                    .overlay(alignment: .leading) {
                        Image(systemName: "arrow.down")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding()
                            .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                    }
            }
            
            if vm.showLocationsList {
                LocationsListView()
            }
        }
        .background(.thickMaterial)
        .cornerRadius(10)
        .shadow(
            color: .black.opacity(0.3),
            radius: 20,
            x: 0,
            y: 15
        )
    }
    
    var mapView: some View {
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations,
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1.0 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture {
                        vm.updateMapLocation(location: location)
                    }
            }
        })
    }
    
    var locationPreviewStack: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if location == vm.mapLocation {
                    LocationPreviewView(location: location)
                        .shadow(
                            color: .black.opacity(0.3),
                            radius: 20
                        )
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .frame(maxWidth: .infinity)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading))
                        )
                }
            }
        }
    }
}
