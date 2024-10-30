//
//  Category.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 19.10.2024.
//

import Foundation

// The Category enum defines various expense categories.
enum Category: String, CaseIterable, Codable, Identifiable {
    var id: String { rawValue }
    
    case food
    case transport
    case entertainment
    case bills
    case other
    case health
    case utilities
    case shopping
    case travel
    case education
    case personalCare
    case groceries
    case others
    
    // Returns the localized name for each category.
    func localizedName() -> String {
        switch self {
        case .food:
            return NSLocalizedString("food", comment: "Food category")
        case .transport:
            return NSLocalizedString("transport", comment: "Transport category")
        case .entertainment:
            return NSLocalizedString("entertainment", comment: "Entertainment category")
        case .bills:
            return NSLocalizedString("bills", comment: "Bills category")
        case .other:
            return NSLocalizedString("other", comment: "Other category")
        case .health:
            return NSLocalizedString("health", comment: "Health category")
        case .utilities:
            return NSLocalizedString("utilities", comment: "Utilities category")
        case .shopping:
            return NSLocalizedString("shopping", comment: "Shopping category")
        case .travel:
            return NSLocalizedString("travel", comment: "Travel category")
        case .education:
            return NSLocalizedString("education", comment: "Education category")
        case .personalCare:
            return NSLocalizedString("personal care", comment: "Personal Care category")
        case .groceries:
            return NSLocalizedString("groceries", comment: "Groceries category")
        case .others:
            return NSLocalizedString("others", comment: "Others category")
        }
    }
    
    // Initializes a Category from a localized string.
    init?(from localized: String) {
        switch localized.lowercased() {
        case "yemek", "food":
            self = .food
        case "ulaşım", "transport":
            self = .transport
        case "eğlence", "entertainment":
            self = .entertainment
        case "faturalar", "bills":
            self = .bills
        case "diğer", "other":
            self = .other
        case "sağlık", "health":
            self = .health
        case "hizmetler", "utilities":
            self = .utilities
        case "alışveriş", "shopping":
            self = .shopping
        case "seyahat", "travel":
            self = .travel
        case "eğitim", "education":
            self = .education
        case "kişisel bakım", "personal care":
            self = .personalCare
        case "bakkaliye", "groceries":
            self = .groceries
        case "others", "diğerleri":
            self = .others
        default:
            return nil
        }
    }
}
