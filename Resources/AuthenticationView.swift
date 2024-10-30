//
//  AuthenticationView.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 20.10.2024.
//

import SwiftUI

// AuthenticationView presents the user authentication interface.
struct AuthenticationView: View {
    var body: some View {
        NavigationView {
            LoginView()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// Preview provider allows previewing the AuthenticationView.
struct AuthenticationView_Previews: PreviewProvider {
    static var previews: some View {
        AuthenticationView()
            .environmentObject(LanguageManager.shared)
    }
}
