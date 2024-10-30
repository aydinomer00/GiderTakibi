//
//  LanguageManager.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import Foundation
import Combine

// The LanguageManager class manages the application's language.
class LanguageManager: ObservableObject {
    // Publishes the current language and listens for changes.
    @Published var currentLanguage: String {
        didSet {
            UserDefaults.standard.set(currentLanguage, forKey: "selectedLanguage")
            updateBundle()
            NotificationCenter.default.post(name: NSNotification.Name("LanguageChanged"), object: nil)
        }
    }
    
    static let shared = LanguageManager()
    
    private var bundle: Bundle?
    
    // Private initializer sets the default language.
    private init() {
        if let savedLanguage = UserDefaults.standard.string(forKey: "selectedLanguage") {
            self.currentLanguage = savedLanguage
        } else {
            self.currentLanguage = Locale.current.language.languageCode?.identifier ?? "en"
        }
        updateBundle()
    }
    
    // Updates the bundle based on the current language.
    private func updateBundle() {
        if let path = Bundle.main.path(forResource: currentLanguage, ofType: "lproj"),
           let langBundle = Bundle(path: path) {
            self.bundle = langBundle
        } else {
            self.bundle = Bundle.main
        }
    }
    
    // Returns a localized string for the given key.
    func localizedString(for key: String) -> String {
        return bundle?.localizedString(forKey: key, value: nil, table: nil) ?? key
    }
}
