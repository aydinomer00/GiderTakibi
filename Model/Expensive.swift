//
//  Expense.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 19.10.2024.
//

import Foundation
import FirebaseFirestore

// The Expense struct represents an individual expense entry.
struct Expense: Identifiable, Codable {
    @DocumentID var id: String?
    var amount: Double
    var category: String
    var date: Date
    var userID: String   // Newly added field
    var latitude: Double?
    var longitude: Double?
}

// Function to update expense categories in Firestore.
func updateFirestoreCategories() {
    let db = Firestore.firestore()
    
    db.collection("expenses").getDocuments { (querySnapshot, error) in
        if let error = error {
            print("Error getting documents: \(error)")
            return
        }
        
        guard let documents = querySnapshot?.documents else {
            print("No documents found")
            return
        }
        
        for document in documents {
            let expense = try? document.data(as: Expense.self)
            if var expense = expense {
                switch expense.category.lowercased() {
                case "yemek":
                    expense.category = Category.food.rawValue
                case "ulaşım":
                    expense.category = Category.transport.rawValue
                case "eğlence":
                    expense.category = Category.entertainment.rawValue
                case "faturalar":
                    expense.category = Category.bills.rawValue
                case "diğer":
                    expense.category = Category.other.rawValue
                default:
                    print("Unknown category: \(expense.category)")
                    continue
                }
                
                if let expenseId = expense.id {
                    do {
                        try db.collection("expenses").document(expenseId).setData(from: expense)
                        print("Updated expense with ID: \(expenseId)")
                    } catch let error {
                        print("Error updating document: \(error)")
                    }
                }
            }
        }
    }
}
