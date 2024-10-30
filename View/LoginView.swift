//
//  LoginView.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 20.10.2024.
//

import SwiftUI
import FirebaseAuth
import Lottie

// The LoginView allows users to log into their account.
struct LoginView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var languageManager: LanguageManager // Ensure LanguageManager is in environment
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            // Background Gradient (Earth Tones)
            LinearGradient(gradient: Gradient(colors: [Color("EarthLight"), Color("EarthDark")]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)  // Covers the entire screen
            
            VStack(spacing: 30) {
                // Lottie Animation
                LottieView(filename: "Animation10")
                    .frame(width: 300, height: 300)
                    .padding(.top, 50)
                
                // Welcome Back Message
                Text("Welcome Back".localized())
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    // Email Input
                    HStack {
                        Image(systemName: "envelope.fill")
                            .foregroundColor(Color("EarthAccent"))
                        TextField("Email".localized(), text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .padding(.leading, 5)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    
                    // Password Input
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(Color("EarthAccent"))
                        SecureField("Password".localized(), text: $password)
                            .padding(.leading, 5)
                    }
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                
                // Log In Button
                Button(action: {
                    loginUser(email: email, password: password)
                }) {
                    Text("Log In".localized())
                        .foregroundColor(.white)
                        .fontWeight(.bold)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(
                            LinearGradient(gradient: Gradient(colors: [Color("EarthAccent"), Color("EarthDark")]),
                                           startPoint: .leading,
                                           endPoint: .trailing)
                        )
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
                .padding(.horizontal, 30)
                
                // Error Message
                if showError {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(8)
                        .padding(.horizontal, 30)
                }
                
                Spacer()
                
                // Navigation to RegisterView
                HStack {
                    Spacer()
                    NavigationLink(destination: RegisterView()) { // Ensure RegisterView is created
                        Text("Don't have account".localized())
                            .foregroundColor(.white)
                            .underline()
                    }
                    Spacer()
                }
                .padding(.bottom, 30)
            }
        }
    }
    
    // Logs in the user using Firebase Authentication.
    func loginUser(email: String, password: String) {
        // Authenticate with Firebase Auth.
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                errorMessage = error.localizedDescription
                showError = true
            } else {
                // Session state will update automatically.
                showError = false
            }
        }
    }
}

// Preview provider for LoginView.
struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .environmentObject(SessionStore())
            .environmentObject(LanguageManager.shared)
    }
}
