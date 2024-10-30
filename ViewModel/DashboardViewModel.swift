//
//  DashboardViewModel.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 19.10.2024.
//

import Foundation
import FirebaseFirestore
import Combine

// The DashboardViewModel class manages data for the dashboard, including category totals and total expenses.
class DashboardViewModel: ObservableObject {
    // Publishes the total amount spent per category.
    @Published var categoryTotals: [String: Double] = [:]
    
    // Publishes the total amount of all expenses.
    @Published var totalExpenses: Double = 0.0
    
    // Publishes the list of expenses.
    @Published var expenses: [Expense] = []
    
    // Instance of LogsViewModel to access expenses.
    private var logsViewModel = LogsViewModel()
    
    // Set to hold any cancellable subscriptions.
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Observes changes to the expenses and recalculates totals accordingly.
        logsViewModel.$expenses
            .sink { [weak self] expenses in
                self?.calculateCategoryTotals(expenses: expenses)
                self?.calculateTotalExpenses(expenses: expenses)
            }
            .store(in: &cancellables)
    }

    // Fetches expenses to calculate category totals.
    func fetchCategoryTotals() {
        logsViewModel.fetchExpenses()
    }

    // Calculates the total amount spent per category.
    private func calculateCategoryTotals(expenses: [Expense]) {
        var totals: [String: Double] = [:]
        for expense in expenses {
            totals[expense.category, default: 0.0] += expense.amount
        }
        categoryTotals = totals
    }
    
    // Calculates the total amount of all expenses.
    private func calculateTotalExpenses(expenses: [Expense]) {
        totalExpenses = expenses.reduce(0) { $0 + $1.amount }
        self.expenses = expenses
    }
}
