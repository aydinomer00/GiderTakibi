//
//  AppDelegate.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 19.10.2024.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

// The AppDelegate class manages the application's lifecycle.
class AppDelegate: NSObject, UIApplicationDelegate {

    // Called when the application has finished launching.
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        // Configure Firebase.
        FirebaseApp.configure()

        // Initialize Firestore and Storage references (optional).
        _ = Firestore.firestore()
        _ = Storage.storage()

        // Listen to user authentication state changes.
        Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                print("User signed in: \(user.email ?? "No Email")")
            } else {
                print("User signed out.")
            }
        }

        return true
    }
}
