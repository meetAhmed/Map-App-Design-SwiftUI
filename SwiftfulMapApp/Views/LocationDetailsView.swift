//
// LocationDetailsView.swift
// SwiftfulMapApp
//
// Created by Ahmed Ali
//

import SwiftUI
import MapKit

struct LocationDetailsView: View {
    @EnvironmentObject private var vm: LocationsViewModel
    let location: Location
    
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                    .shadow(
                        color: .black.opacity(0.3),
                        radius: 10,
                        x: 0,
                        y: 20
                    )
                
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    Divider()
                    descriptionSection
                    Divider()
                    mapView
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

struct LocationDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        LocationDetailsView(location: LocationsDataService.locations.first!)
    }
}

private extension LocationDetailsView {
    var imageSection: some View {
        TabView {
            ForEach(location.imageNames, id: \.self) { imageName in
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: UIDevice.current.userInterfaceIdiom == .pad ? nil : UIScreen.main.bounds.width)
                    .clipped()
            }
        }
        .frame(height: 500)
        .tabViewStyle(PageTabViewStyle())
    }

    var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            
            Text(location.cityName)
                .font(.title3)
                .foregroundColor(.secondary)
        }
    }
    
    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.description)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if let url = URL(string: location.link) {
                Link("Read more on Wikipedia", destination: url)
                    .font(.headline)
                    .tint(.blue)
            }
        }
    }
    
    var mapView: some View {
        Map(coordinateRegion: .constant(MKCoordinateRegion(center: location.coordinates, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))),
            annotationItems: [location],
            annotationContent: { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnotationView()
                    .shadow(radius: 10)
            }
        })
        .aspectRatio(1, contentMode: .fit)
        .cornerRadius(30)
        .allowsHitTesting(false)
    }
    
    var backButton: some View {
        Button {
            vm.sheetLocation = nil
        } label: {
                Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundColor(.primary)
                .background(.thickMaterial)
                .cornerRadius(10)
                .shadow(radius: 4)
                .padding()
        }
    }
}
