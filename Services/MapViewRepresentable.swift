//
//  MapViewRepresentable.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import SwiftUI
import MapKit

// The MapViewRepresentable makes UIKit's MKMapView usable in SwiftUI.
struct MapViewRepresentable: UIViewRepresentable {
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    @Binding var region: MKCoordinateRegion
    @Binding var annotations: [SelectedLocation]
    
    // The Coordinator class conforms to MKMapViewDelegate and UIGestureRecognizerDelegate protocols.
    class Coordinator: NSObject, MKMapViewDelegate, UIGestureRecognizerDelegate {
        var parent: MapViewRepresentable
        
        init(_ parent: MapViewRepresentable) {
            self.parent = parent
        }
        
        // Handles the long press gesture.
        @objc func handleLongPress(gestureRecognizer: UILongPressGestureRecognizer) {
            if gestureRecognizer.state == .began {
                let mapView = gestureRecognizer.view as! MKMapView
                let touchPoint = gestureRecognizer.location(in: mapView)
                let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
                
                parent.annotations.removeAll()
                parent.annotations.append(SelectedLocation(coordinate: coordinate))
                parent.selectedCoordinate = coordinate
            }
        }
    }
    
    // Creates the Coordinator.
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // Creates and configures the MKMapView.
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.region = region
        
        let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(Coordinator.handleLongPress(gestureRecognizer:)))
        longPress.minimumPressDuration = 1.0
        mapView.addGestureRecognizer(longPress)
        
        return mapView
    }
    
    // Updates the MKMapView.
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.setRegion(region, animated: true)
        
        uiView.removeAnnotations(uiView.annotations)
        for location in annotations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location.coordinate
            uiView.addAnnotation(annotation)
        }
    }
}
