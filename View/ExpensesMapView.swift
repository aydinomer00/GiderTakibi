//
//  ExpensesMapView.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import SwiftUI
import MapKit

// The ExpensesMapView displays expenses as annotations on a map.
struct ExpensesMapView: View {
    // Observes the LogsViewModel for expense data.
    @ObservedObject var viewModel = LogsViewModel()
    
    // Initial region centered around Turkey.
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.925533, longitude: 32.866287), // Centered in Turkey
        span: MKCoordinateSpan(latitudeDelta: 5.0, longitudeDelta: 5.0)
    )
    
    var body: some View {
        Map(coordinateRegion: $region, annotationItems: viewModel.expenses.filter { $0.latitude != nil && $0.longitude != nil }) { expense in
            MapAnnotation(coordinate: CLLocationCoordinate2D(latitude: expense.latitude!, longitude: expense.longitude!)) {
                VStack {
                    Image(systemName: self.getIconName(for: expense.category))
                        .foregroundColor(self.getColor(for: expense.category))
                    Text(String(format: "%.2f ₺", expense.amount))
                        .font(.caption)
                        .padding(5)
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(5)
                }
            }
        }
        .onAppear {
            viewModel.fetchExpenses()
        }
    }
    
    // Returns the appropriate icon name based on the expense category.
    func getIconName(for category: String) -> String {
        guard let categoryEnum = Category(from: category) else {
            return "questionmark.circle.fill"
        }
        switch categoryEnum {
        case .food:
            return "fork.knife"
        case .transport:
            return "car.fill"
        case .entertainment:
            return "gamecontroller.fill"
        case .bills:
            return "doc.text.fill"
        case .other:
            return "ellipsis.circle.fill"
        case .health:
            return "heart.fill"
        case .utilities:
            return "bolt.fill"
        case .shopping:
            return "cart.fill"
        case .travel:
            return "airplane"
        case .education:
            return "book.fill"
        case .personalCare:
            return "sparkles"  // Suitable icon for 'personalCare' category
        case .groceries:
            return "bag.fill"
        case .others:
            return "questionmark.circle.fill"
        }
    }
    
    // Returns the appropriate color based on the expense category.
    func getColor(for category: String) -> Color {
        guard let categoryEnum = Category(from: category) else {
            return .gray
        }
        switch categoryEnum {
        case .food:
            return .red
        case .transport:
            return .blue
        case .entertainment:
            return .green
        case .bills:
            return .orange
        case .other:
            return .purple
        case .health:
            return .pink
        case .utilities:
            return .yellow
        case .shopping:
            return .teal
        case .travel:
            return .cyan
        case .education:
            return .indigo
        case .personalCare:
            return .mint
        case .groceries:
            return .brown
        case .others:
            return .gray
        }
    }
}

// Preview provider for ExpensesMapView.
struct ExpensesMapView_Previews: PreviewProvider {
    static var previews: some View {
        ExpensesMapView()
    }
}
