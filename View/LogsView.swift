//
//  LogsView.swift
//  GiderTakibi
//
//  Created by Omer Murat Aydin on 21.10.2024.
//

import SwiftUI
import CoreLocation

// The LogsView displays a list of expenses and allows adding new expenses.
struct LogsView: View {
    @EnvironmentObject var languageManager: LanguageManager
    @StateObject var viewModel = LogsViewModel()
    
    // State variables for adding a new expense.
    @State private var amount: String = ""
    @State private var selectedCategory: Category = .food
    @State private var sortAscending: Bool = true
    @State private var selectedExpense: Expense?
    @State private var showEditExpense = false
    
    @State private var wantsToAddLocation: Bool = false
    @State private var selectedCoordinate: CLLocationCoordinate2D? = nil
    @State private var showLocationPicker: Bool = false
    
    // Newly added state variable for date selection.
    @State private var wantsToAddDate: Bool = false
    @State private var selectedDate: Date = Date()
    
    // Computes the sorted list of expenses based on the sortAscending flag.
    var sortedExpenses: [Expense] {
        sortAscending ? viewModel.expenses.sorted { $0.amount < $1.amount } :
                        viewModel.expenses.sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        NavigationView {
            VStack {
                // Form for adding a new expense and sorting options.
                Form {
                    // Section for adding a new expense.
                    Section(header: Text("Add New Expense".localized())) {
                        // Amount input field.
                        TextField("Amount".localized(), text: $amount)
                            .keyboardType(.decimalPad)
                        
                        // Category picker.
                        Picker("Category".localized(), selection: $selectedCategory) {
                            ForEach(Category.allCases, id: \.self) { category in
                                Text(category.localizedName()).tag(category)
                            }
                        }
                        // Use default picker style to accommodate more categories.
                        
                        // Toggle for adding a date.
                        Toggle(isOn: $wantsToAddDate) {
                            Text("Add Date?".localized())
                        }
                        
                        // DatePicker shown if the toggle is on.
                        if wantsToAddDate {
                            DatePicker("Select Date".localized(), selection: $selectedDate, displayedComponents: .date)
                                .datePickerStyle(GraphicalDatePickerStyle())
                        }
                        
                        // Toggle for adding location.
                        Toggle(isOn: $wantsToAddLocation) {
                            Text("Add Location?".localized())
                        }
                        
                        // Button to select location if the toggle is on.
                        if wantsToAddLocation {
                            Button(action: {
                                showLocationPicker = true
                            }) {
                                Text(selectedCoordinate != nil ? "Location Selected".localized() : "Select Location".localized())
                                    .foregroundColor(.blue)
                            }
                            .sheet(isPresented: $showLocationPicker) {
                                SelectLocationView(selectedCoordinate: $selectedCoordinate)
                            }
                        }
                        
                        // Add expense button.
                        Button(action: {
                            addExpense()
                        }) {
                            Text("Add".localized())
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                    
                    // Section for sorting expenses.
                    Section(header: Text("Sort Expenses".localized())) {
                        Toggle(isOn: $sortAscending) {
                            Text(sortAscending ? "Amount Ascending".localized() : "Amount Descending".localized())
                        }
                    }
                }
                
                // List of expenses.
                List {
                    ForEach(sortedExpenses) { expense in
                        HStack {
                            Image(systemName: self.getIconName(for: expense.category))
                                .foregroundColor(self.getColor(for: expense.category))
                            VStack(alignment: .leading) {
                                Text(self.getLocalizedCategory(for: expense.category))
                                    .fontWeight(.medium)
                                Text("Date: \(formattedDate(expense.date))") // Displays expense date.
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            Text(String(format: "%.2f ₺", expense.amount))
                                .foregroundColor(.gray)
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            self.selectedExpense = expense
                            self.showEditExpense = true
                        }
                    }
                    .onDelete(perform: deleteExpense)
                }
            }
            .navigationBarTitle("Expenses".localized(), displayMode: .inline)
            .sheet(item: $selectedExpense) { expense in
                EditExpenseView(viewModel: viewModel, expense: expense)
            }
        }
        .onAppear {
            self.viewModel.fetchExpenses()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    // Adds a new expense using the provided form data.
    func addExpense() {
        if let amount = Double(self.amount) {
            let expenseDate = wantsToAddDate ? selectedDate : Date()
            self.viewModel.addExpense(
                amount: amount,
                category: self.selectedCategory.rawValue,
                date: expenseDate,
                latitude: wantsToAddLocation ? selectedCoordinate?.latitude : nil,
                longitude: wantsToAddLocation ? selectedCoordinate?.longitude : nil
            )
            // Clear the form.
            self.amount = ""
            self.selectedDate = Date()
            self.wantsToAddDate = false
            if !wantsToAddLocation {
                self.selectedCoordinate = nil
            }
        }
    }
    
    // Deletes an expense from the list.
    func deleteExpense(at offsets: IndexSet) {
        offsets.forEach { index in
            let expense = sortedExpenses[index]
            viewModel.deleteExpense(expense: expense)
        }
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
    
    // Formats the date to a readable string.
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX") // English locale setting
        formatter.dateStyle = .medium
        formatter.timeStyle = .none // If you don't want to display time
        return formatter.string(from: date)
    }
}

// Preview provider for LogsView.
struct LogsView_Previews: PreviewProvider {
    static var previews: some View {
        LogsView()
            .environmentObject(LanguageManager.shared)
    }
}
