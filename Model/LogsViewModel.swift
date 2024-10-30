//
//  LogsViewModel.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 20.10.2024.
//

import Foundation
import FirebaseFirestore
import Combine

class LogsViewModel: ObservableObject {
    @Published var expenses: [Expense] = []

    private var db = Firestore.firestore()
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchExpenses()
    }

    func fetchExpenses() {
        db.collection("expenses")
            .order(by: "date", descending: true)
            .addSnapshotListener { [weak self] querySnapshot, error in
                if let error = error {
                    print("Hata: \(error.localizedDescription)")
                    return
                }

                self?.expenses = querySnapshot?.documents.compactMap { document in
                    try? document.data(as: Expense.self)
                } ?? []
            }
    }

    func addExpense(amount: Double, category: String) {
        let newExpense = Expense(amount: amount, category: category, date: Date())
        do {
            _ = try db.collection("expenses").addDocument(from: newExpense)
        } catch let error {
            print("Veri ekleme hatası: \(error.localizedDescription)")
        }
    }
}
