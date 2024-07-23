//
//  StaticMapView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 06/11/23.
//

import SwiftUI
import MapKit

struct StaticMapView: View {
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var userTrackingMode: MapUserTrackingMode = .follow
    
    @StateObject private var locationManager = LocationManager()
    
    @State private var markers: [MapCoordinates] = [
        MapCoordinates(id: UUID().uuidString, coordinate: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194))
    ]
    
    @Binding var latitude: Double
    @Binding var longitude: Double
    var lockToPin: Bool
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: markers) { marker in
                    MapMarker(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), tint: .green)
                }
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    locationManager.requestLocationAuthorization()
                    userTrackingMode = .follow
                }
                .onChange(of: region.center) { newCenter in
                    if lockToPin{
                        region.center = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    }
                }
            }.ignoresSafeArea(.all)
        }
    }
}



#Preview {
    StaticMapView(latitude: .constant(37.7749), longitude: .constant(-122.4194), lockToPin: false)
}
