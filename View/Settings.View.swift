//
//  SettingsView.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 20.10.2024.
//

import SwiftUI
import FirebaseAuth
import FirebaseFirestore

// The SettingsView allows users to view and edit their settings.
struct SettingsView: View {
    @EnvironmentObject var session: SessionStore
    @ObservedObject var viewModel = SettingsViewModel()
    
    // State variables for user name editing.
    @State private var userName: String = UserDefaults.standard.string(forKey: "userName") ?? ""
    @State private var isEditingName: Bool = false
    
    var body: some View {
        NavigationView {
            Form {
                // User Information Section.
                Section(header: Text("User Information")) {
                    if isEditingName {
                        // TextField for editing the user's name.
                        TextField("Enter your name", text: $userName, onCommit: {
                            UserDefaults.standard.set(self.userName, forKey: "userName")
                            self.isEditingName = false
                        })
                    } else {
                        // Display the user's name.
                        HStack {
                            Text("Name:")
                            Spacer()
                            Text(userName.isEmpty ? "Unknown" : userName)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.isEditingName = true
                        }
                    }
                    
                    // Display total expenses.
                    HStack {
                        Text("Total Expenses:")
                        Spacer()
                        Text(String(format: "%.2f ₺", viewModel.totalExpenses))
                    }
                }
                
                // Logout Section.
                Section {
                    Button(action: {
                        session.signOut()
                    }) {
                        Text("Log Out")
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.red)
                            .cornerRadius(5.0)
                            .padding(.horizontal, 20)
                    }
                }
            }
            .navigationBarTitle("Settings", displayMode: .inline)
            .onAppear {
                viewModel.fetchTotalExpenses()
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

// The SettingsViewModel manages the data for the SettingsView.
class SettingsViewModel: ObservableObject {
    // Publishes the total amount of expenses.
    @Published var totalExpenses: Double = 0.0
    
    // Firestore database reference.
    private var db = Firestore.firestore()
    
    // Fetches the total expenses for the authenticated user.
    func fetchTotalExpenses() {
        guard let userID = Auth.auth().currentUser?.uid else { return }
        db.collection("expenses")
            .whereField("userID", isEqualTo: userID)
            .getDocuments { snapshot, error in
                if let error = error {
                    print("Error fetching expenses: \(error)")
                    return
                }
                
                let expenses = snapshot?.documents.compactMap { document -> Expense? in
                    try? document.data(as: Expense.self)
                } ?? []
                
                DispatchQueue.main.async {
                    self.totalExpenses = expenses.reduce(0) { $0 + $1.amount }
                }
            }
    }
}

// Preview provider for SettingsView.
struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SessionStore())
    }
}
