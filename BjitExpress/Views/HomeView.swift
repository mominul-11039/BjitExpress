//
//  HomeView.swift
//  BjitExpress
//
//  Created by Sadat Ahmed on 18/5/23.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var locationVM = LocationViewModel()
        
    var body: some View {
        VStack(spacing: 0) {
            MapView(userLocation: locationVM.userLocation)
                .ignoresSafeArea(.all)
            
            StartTrackingBtnView(location: locationVM)
                .background()
                .background(.ultraThinMaterial)
        } //: VSTACK
        .background(.ultraThinMaterial)
        // .ignoresSafeArea()
        .onAppear {
            locationVM.requestLocation()
        }
    }
}

struct MapView: UIViewRepresentable {
    var userLocation: CLLocationCoordinate2D?
    
    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        guard let location = userLocation else { return }
        
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        
        uiView.setRegion(region, animated: true)
        
        // Add a pin annotation for the user's location
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotation(annotation)
        
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
