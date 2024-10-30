//
//  ContentView.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 19.10.2024.
//

import SwiftUI
import FirebaseAuth

// The ContentView determines whether to show the MainTabView or the AuthenticationView based on user authentication status.
struct ContentView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var languageManager: LanguageManager

    var body: some View {
        Group {
            if session.user != nil {
                MainTabView()
                    .onAppear {
                        // Fetch expenses when the user is authenticated.
                        LogsViewModel().fetchExpenses()
                    }
            } else {
                AuthenticationView()
            }
        }
        .onAppear {
            self.session.listen()
        }
    }
}

// Preview provider for ContentView.
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(SessionStore())
            .environmentObject(LanguageManager.shared)
    }
}
