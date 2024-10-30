//
//  SelectLocationView.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import SwiftUI
import MapKit

// The SelectLocationView allows users to select a location on the map.
struct SelectLocationView: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var selectedCoordinate: CLLocationCoordinate2D?
    
    // Initial region centered around Turkey.
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.925533, longitude: 32.866287), // Centered in Turkey
        span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
    )
    
    // List of annotations on the map.
    @State private var annotations: [SelectedLocation] = []
    
    var body: some View {
        NavigationView {
            VStack {
                // MapViewRepresentable displays the map.
                MapViewRepresentable(selectedCoordinate: $selectedCoordinate, region: $region, annotations: $annotations)
                    .edgesIgnoringSafeArea(.all)
                
                // "Done" button to confirm the selected location.
                Button(action: {
                    if let coordinate = annotations.first?.coordinate {
                        selectedCoordinate = coordinate
                        presentationMode.wrappedValue.dismiss()
                    }
                }) {
                    Text("Done")
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding()
                }
            }
            .navigationBarTitle("Select Location", displayMode: .inline)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Preview provider for SelectLocationView.
struct SelectLocationView_Previews: PreviewProvider {
    static var previews: some View {
        SelectLocationView(selectedCoordinate: .constant(nil))
    }
}
