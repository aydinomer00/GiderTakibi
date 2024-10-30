//
//  LogsViewModel.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 19.10.2024.
//

import Foundation
import FirebaseFirestore
import Combine
import FirebaseAuth

// The LogsViewModel class manages the retrieval and manipulation of expense logs.
class LogsViewModel: ObservableObject {
    // Publishes the list of expenses.
    @Published var expenses: [Expense] = []
    
    // Firestore database reference.
    private var db = Firestore.firestore()
    
    // Set to hold any cancellable subscriptions.
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        // Do not call fetchExpenses() here to prevent it from being called before user authentication.
    }
    
    // Fetches expenses from Firestore for the authenticated user.
    func fetchExpenses() {
        guard let user = Auth.auth().currentUser else {
            print("User is not authenticated.")
            self.expenses = []
            return
        }
        let userID = user.uid
        db.collection("expenses")
            .whereField("userID", isEqualTo: userID)
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                    return
                }
                
                self?.expenses = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Expense.self)
                } ?? []
            }
    }
    
    // Adds a new expense to Firestore.
    func addExpense(amount: Double, category: String, date: Date, latitude: Double?, longitude: Double?) {
        guard let user = Auth.auth().currentUser else {
            print("User is not authenticated.")
            return
        }
        let userID = user.uid
        let newExpense = Expense(amount: amount, category: category, date: date, userID: userID, latitude: latitude, longitude: longitude)
        do {
            _ = try db.collection("expenses").addDocument(from: newExpense)
        } catch let error {
            print("Error adding data: \(error.localizedDescription)")
        }
    }

    // Deletes an expense from Firestore.
    func deleteExpense(expense: Expense) {
        guard let user = Auth.auth().currentUser else {
            print("User is not authenticated.")
            return
        }
        if let expenseId = expense.id, expense.userID == user.uid {
            db.collection("expenses").document(expenseId).delete { error in
                if let error = error {
                    print("Error deleting expense: \(error.localizedDescription)")
                } else {
                    print("Expense successfully deleted.")
                }
            }
        } else {
            print("You do not have permission to delete this expense.")
        }
    }

    // Updates an existing expense in Firestore.
    func updateExpense(expense: Expense) {
        guard let user = Auth.auth().currentUser else {
            print("User is not authenticated.")
            return
        }
        if let expenseId = expense.id, expense.userID == user.uid {
            do {
                try db.collection("expenses").document(expenseId).setData(from: expense)
            } catch let error {
                print("Error updating expense: \(error.localizedDescription)")
            }
        } else {
            print("You do not have permission to update this expense.")
        }
    }
}
