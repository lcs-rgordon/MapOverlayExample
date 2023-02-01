//
//  ContentView.swift
//  MapOverlayExample
//
//  Created by Russell Gordon on 2023-02-01.
//

import MapKit
import SwiftUI

// NOTE: Based entirely on this answer on SO...
//       https://stackoverflow.com/a/56943282
struct ContentView: View {
    
    @State var route: MKPolyline?
    
    var body: some View {
        MapView(route: $route)
            .onAppear {
                self.findCoffee()
            }
    }
    
    func findCoffee() {
        let start = CLLocationCoordinate2D(latitude: 37.332693, longitude: -122.03071)
        let region = MKCoordinateRegion(center: start, latitudinalMeters: 2000, longitudinalMeters: 2000)
        
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "coffee"
        request.region = region
        
        MKLocalSearch(request: request).start { response, error in
            guard let destination = response?.mapItems.first else { return }
            
            let request = MKDirections.Request()
            request.source = MKMapItem(placemark: MKPlacemark(coordinate: start))
            request.destination = destination
            MKDirections(request: request).calculate { directionsResponse, _ in
                self.route = directionsResponse?.routes.first?.polyline
            }
        }
    }
    
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
