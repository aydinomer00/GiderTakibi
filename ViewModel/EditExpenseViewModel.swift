//
//  EditExpenseViewModel.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import Foundation
import CoreLocation
import Combine

// The EditExpenseViewModel class manages the state and logic for editing an expense.
class EditExpenseViewModel: ObservableObject {
    // Publishes the name of the location.
    @Published var locationName: String = ""
    
    // Set to hold any cancellable subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    // Fetches the location name based on the provided coordinate.
    func fetchLocationName(from coordinate: CLLocationCoordinate2D?) {
        guard let coordinate = coordinate else {
            self.locationName = "No Location".localized()
            return
        }
        
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let error = error {
                print("Geocoding error: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.locationName = "Unknown Location".localized()
                }
                return
            }
            
            if let placemark = placemarks?.first {
                let name = placemark.name ?? ""
                let locality = placemark.locality ?? ""
                let administrativeArea = placemark.administrativeArea ?? ""
                let country = placemark.country ?? ""
                
                let fullName = "\(name), \(locality), \(administrativeArea), \(country)"
                
                DispatchQueue.main.async {
                    self?.locationName = fullName
                }
            } else {
                DispatchQueue.main.async {
                    self?.locationName = "Unknown Location".localized()
                }
            }
        }
    }
}
