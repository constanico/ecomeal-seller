//
//  EditableMarkerMapView.swift
//  ECOMEAL Seller
//
//  Created by Jason Leonardo on 28/10/23.
//

import SwiftUI
import MapKit

struct EditableMarkerMapView: View {
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
    
    var body: some View {
        NavigationView {
            VStack {
                Map(coordinateRegion: $region, showsUserLocation: true, userTrackingMode: $userTrackingMode, annotationItems: markers) { marker in
                    MapMarker(coordinate: marker.coordinate, tint: .green)
                }
                .edgesIgnoringSafeArea(.bottom)
                .onAppear {
                    locationManager.requestLocationAuthorization()
                    userTrackingMode = .follow
                }
                .onChange(of: region.center) { newCenter in
                    userTrackingMode = .follow
                }
                .onTapGesture(coordinateSpace: .global) { location in
                    let coordinate = mapViewCoordinate(for: location)
                    let pinnedCoordinate = coordinate
                    if markers.isEmpty{
                        markers.append(MapCoordinates(id: UUID().uuidString, coordinate: pinnedCoordinate))
                    }else{
                        markers.removeAll()
                        markers.append(MapCoordinates(id: UUID().uuidString, coordinate: pinnedCoordinate))
                    }
                    latitude = coordinate.latitude
                    longitude = coordinate.longitude
                
                }
                
            }
        }
    }
    
    private func mapViewCoordinate(for gestureLocation: CGPoint) -> CLLocationCoordinate2D {
        let mapViewFrame = UIScreen.main.bounds
        let mapViewWidth = mapViewFrame.size.width
        let mapViewHeight = mapViewFrame.size.height
        let tapX = gestureLocation.x - 200
        let tapY = gestureLocation.y + 430
        let mapX = (tapX / mapViewWidth) * CGFloat(region.span.longitudeDelta) + CGFloat(region.center.longitude)
        let mapY = (1 - (tapY / mapViewHeight)) * CGFloat(region.span.latitudeDelta) + CGFloat(region.center.latitude)
        
        return CLLocationCoordinate2D(latitude: CLLocationDegrees(mapY), longitude: CLLocationDegrees(mapX))
    }
}


#Preview {
    EditableMarkerMapView(latitude: .constant(0), longitude: .constant(0))
}

