//
//  SessionStore.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 20.10.2024.
//

import Foundation
import FirebaseAuth
import Combine

// The SessionStore class manages the user's session state.
class SessionStore: ObservableObject {
    // Publishes the user.
    @Published var user: User? = nil
    var handle: AuthStateDidChangeListenerHandle?

    // Starts listening to user authentication state changes.
    func listen() {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            if let user = user {
                DispatchQueue.main.async {
                    self.user = user
                    print("User signed in: \(user.email ?? "No Email")")
                }
            } else {
                DispatchQueue.main.async {
                    self.user = nil
                    print("User signed out.")
                }
            }
        }
    }

    // Signs out the user.
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }

    // Removes the listener when SessionStore is deallocated.
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}
