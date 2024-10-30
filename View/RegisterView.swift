import SwiftUI
import FirebaseAuth
import Lottie

// The RegisterView allows users to create a new account.
struct RegisterView: View {
    @EnvironmentObject var session: SessionStore
    @EnvironmentObject var languageManager: LanguageManager // Ensure LanguageManager is in environment
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @State private var showError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        ZStack {
            // Background Gradient (Earth Tones)
            LinearGradient(gradient: Gradient(colors: [Color("EarthLight"), Color("EarthDark")]),
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
                .edgesIgnoringSafeArea(.all)
            
            ScrollView {
                VStack(spacing: 30) {
                    // Lottie Animation
                    LottieView(filename: "Animation10")
                        .frame(width: 300, height: 300)
                        .padding(.top, 50)
                    
                    // Create Account Message
                    Text("Create Account".localized())
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
                        
                        // Confirm Password Input
                        HStack {
                            Image(systemName: "lock.fill")
                                .foregroundColor(Color("EarthAccent"))
                            SecureField("Confirm Password".localized(), text: $confirmPassword)
                                .padding(.leading, 5)
                        }
                        .padding()
                        .background(Color.white.opacity(0.8))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                    }
                    .padding(.horizontal, 30)
                    
                    // Register Button
                    Button(action: {
                        registerUser(email: email, password: password, confirmPassword: confirmPassword)
                    }) {
                        Text("Register".localized())
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
                    
                    // Navigation to LoginView
                    HStack {
                        Spacer()
                        NavigationLink(destination: LoginView()) {
                            Text("Already Have Account".localized())
                                .foregroundColor(.white)
                                .underline()
                        }
                        Spacer()
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
    
    // Registers a new user using Firebase Authentication.
    func registerUser(email: String, password: String, confirmPassword: String) {
        // Password validation.
        guard password == confirmPassword else {
            errorMessage = "passwords_do_not_match".localized()
            showError = true
            return
        }
        
        // Register with Firebase Auth.
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
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

// Preview provider for RegisterView.
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
            .environmentObject(SessionStore())
            .environmentObject(LanguageManager.shared)
    }
}
