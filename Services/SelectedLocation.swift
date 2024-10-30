//
//  SelectedLocation.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import Foundation
import CoreLocation

// The SelectedLocation struct represents a selected location.
struct SelectedLocation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}
