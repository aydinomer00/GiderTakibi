//
//  DashboardViewModel.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 20.10.2024.
//

import Foundation
import FirebaseFirestore
import Combine

class DashboardViewModel: ObservableObject {
    @Published var categoryTotals: [String: Double] = [:]

    private var logsViewModel = LogsViewModel()
    private var cancellables = Set<AnyCancellable>()

    init() {
        logsViewModel.$expenses
            .sink { [weak self] expenses in
                self?.calculateCategoryTotals(expenses: expenses)
            }
            .store(in: &cancellables)
    }

    func fetchCategoryTotals() {
        logsViewModel.fetchExpenses()
    }

    private func calculateCategoryTotals(expenses: [Expense]) {
        var totals: [String: Double] = [:]
        for expense in expenses {
            totals[expense.category, default: 0.0] += expense.amount
        }
        categoryTotals = totals
    }
}
