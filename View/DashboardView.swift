//
//  DashboardView.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 19.10.2024.
//

import SwiftUI

// The DashboardView displays an overview of expenses, including total expenses and category breakdown.
struct DashboardView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject var viewModel = DashboardViewModel()

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {

                    // Total Expenses Card.
                    TotalExpensesCard(totalExpenses: viewModel.totalExpenses)
                        .padding(.horizontal, 20)

                    // Pie Chart Card or No Data Card.
                    if !viewModel.categoryTotals.isEmpty {
                        PieChartCard(categoryTotals: viewModel.categoryTotals)
                            .padding(.horizontal, 20)
                    } else {
                        NoDataCard(message: "No Expenses Yet".localized())
                            .padding(.horizontal, 20)
                    }

                    // Breakdown Section.
                    if !viewModel.expenses.isEmpty {
                        Text("Breakdown".localized())
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.horizontal, 20)

                        BreakdownList(expenses: viewModel.expenses)
                            .padding(.horizontal, 20)
                    }

                    Spacer()
                }
                .navigationBarTitle("Dashboard".localized(), displayMode: .inline)
            }
            .background(Color(.systemGroupedBackground))
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .onAppear {
            viewModel.fetchCategoryTotals()
        }
    }
}

// The TotalExpensesCard displays the total amount of expenses.
struct TotalExpensesCard: View {
    var totalExpenses: Double

    var body: some View {
        VStack {
            Text("Total Expenses".localized())
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.top, 20)

            Text(String(format: "%.2f ₺", totalExpenses))
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(.primary)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// The PieChartCard displays a pie chart of expenses by category.
struct PieChartCard: View {
    var categoryTotals: [String: Double]

    var body: some View {
        VStack {
            Text("Expenses by Category".localized())
                .font(.headline)
                .foregroundColor(.primary)
                .padding(.top, 10)

            PieChartView(
                data: Array(categoryTotals.values),
                labels: Array(categoryTotals.keys.map { Category(rawValue: $0)?.localizedName() ?? $0 }),
                colors: Array(categoryTotals.keys.map { getColor(for: $0) })
            )
            .frame(height: 300)
            .padding()
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }

    // Returns the appropriate color based on the category.
    func getColor(for category: String) -> Color {
        guard let categoryEnum = Category(from: category) else {
            return .gray
        }
        switch categoryEnum {
        case .food:
            return .red
        case .transport:
            return .blue
        case .entertainment:
            return .green
        case .bills:
            return .orange
        case .other:
            return .purple
        case .health:
            return .pink
        case .utilities:
            return .yellow
        case .shopping:
            return .teal
        case .travel:
            return .cyan
        case .education:
            return .indigo
        case .personalCare:
            return .mint
        case .groceries:
            return .brown
        case .others:
            return .gray
        }
    }
}

// The NoDataCard displays a message when there are no expenses.
struct NoDataCard: View {
    var message: String

    var body: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.yellow)
                .padding(.top, 20)

            Text(message)
                .font(.title2)
                .foregroundColor(.primary)
                .padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// The BreakdownList displays a list of expenses with their details.
struct BreakdownList: View {
    var expenses: [Expense]

    var body: some View {
        VStack(spacing: 10) {
            ForEach(expenses) { expense in
                ExpenseRow(expense: expense)
            }
        }
    }
}

// The ExpenseRow displays individual expense details.
struct ExpenseRow: View {
    var expense: Expense

    var body: some View {
        HStack {
            Image(systemName: getIconName(for: expense.category))
                .foregroundColor(getColor(for: expense.category))
                .frame(width: 25, height: 25)

            Text(getLocalizedCategory(for: expense.category))
                .fontWeight(.medium)
                .foregroundColor(.primary)

            Spacer()

            Text(String(format: "%.2f ₺", expense.amount))
                .foregroundColor(.primary)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white)
                .shadow(color: Color.black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }

    // Returns the appropriate icon name based on the expense category.
    func getIconName(for category: String) -> String {
        guard let categoryEnum = Category(from: category) else {
            return "questionmark.circle.fill"
        }
        switch categoryEnum {
        case .food:
            return "fork.knife"
        case .transport:
            return "car.fill"
        case .entertainment:
            return "gamecontroller.fill"
        case .bills:
            return "doc.text.fill"
        case .other:
            return "ellipsis.circle.fill"
        case .health:
            return "heart.fill"
        case .utilities:
            return "bolt.fill"
        case .shopping:
            return "cart.fill"
        case .travel:
            return "airplane"
        case .education:
            return "book.fill"
        case .personalCare:
            return "sparkles"  // Suitable icon for 'personalCare' category
        case .groceries:
            return "bag.fill"
        case .others:
            return "questionmark.circle.fill"
        }
    }

    // Returns the appropriate color based on the expense category.
    func getColor(for category: String) -> Color {
        guard let categoryEnum = Category(from: category) else {
            return .gray
        }
        switch categoryEnum {
        case .food:
            return .red
        case .transport:
            return .blue
        case .entertainment:
            return .green
        case .bills:
            return .orange
        case .other:
            return .purple
        case .health:
            return .pink
        case .utilities:
            return .yellow
        case .shopping:
            return .teal
        case .travel:
            return .cyan
        case .education:
            return .indigo
        case .personalCare:
            return .mint
        case .groceries:
            return .brown
        case .others:
            return .gray
        }
    }
    
    // Returns the localized name for the expense category.
    func getLocalizedCategory(for category: String) -> String {
        guard let categoryEnum = Category(from: category) else {
            return category.localized()
        }
        return categoryEnum.localizedName()
    }
}

// Preview provider for DashboardView.
struct DashboardView_Previews: PreviewProvider {
    static var previews: some View {
        DashboardView()
            .environmentObject(LanguageManager.shared)
    }
}
