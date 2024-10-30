//
//  ExpenseTrackerApp.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 19.10.2024.
//

import SwiftUI
import FirebaseAuth

@main
struct ExpenseTrackerApp: App {
    // Integrate AppDelegate.
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    // Listen to user session status with @StateObject.
    @StateObject var session = SessionStore()
    
    // Language management with @StateObject.
    @StateObject var languageManager = LanguageManager.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(session) // Add SessionStore as environmentObject.
                .environmentObject(languageManager) // Add LanguageManager as environmentObject.
                // .environmentObject(LocationManager.shared) // Not needed because location is handled manually.
        }
    }
}
