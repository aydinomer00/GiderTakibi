//
//  String+Localization.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import Foundation

// The String extension adds localization functionality.
extension String {
    // Returns a localized version of the string.
    func localized() -> String {
        return NSLocalizedString(self, comment: "")
    }
}
