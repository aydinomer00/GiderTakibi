//
//  LanguageSettings.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import Foundation
import SwiftUI

// The LanguageSettings class manages the user's selected language.
class LanguageSettings: ObservableObject {
    // Publishes the selected language and saves changes.
    @Published var selectedLanguage: String {
        didSet {
            UserDefaults.standard.set([selectedLanguage], forKey: "AppleLanguages")
            UserDefaults.standard.synchronize()
        }
    }

    // Initializer sets the default language or loads the saved language.
    init() {
        let languages = UserDefaults.standard.stringArray(forKey: "AppleLanguages") ?? ["tr"]
        selectedLanguage = languages.first ?? "tr"
    }
}
