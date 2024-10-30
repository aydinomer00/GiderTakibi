//
//  EditExpenseView.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 19.10.2024.
//

import SwiftUI
import CoreLocation

// The EditExpenseView allows users to edit an existing expense.
struct EditExpenseView: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var viewModel: LogsViewModel
    @State var expense: Expense

    // State variables for form fields.
    @State private var amount: String
    @State private var selectedCategory: Category
    @State private var wantsToEditLocation: Bool
    @State private var selectedCoordinate: CLLocationCoordinate2D?
    @State private var showLocationPicker: Bool = false

    // Newly added state variable for date selection.
    @State private var wantsToEditDate: Bool
    @State private var selectedDate: Date

    // Initializer to set up the state variables.
    init(viewModel: LogsViewModel, expense: Expense) {
        self.viewModel = viewModel
        _expense = State(initialValue: expense)
        _amount = State(initialValue: String(format: "%.2f", expense.amount))
        _selectedCategory = State(initialValue: Category(from: expense.category) ?? .others)
        _wantsToEditLocation = State(initialValue: expense.latitude != nil && expense.longitude != nil)
        if let latitude = expense.latitude, let longitude = expense.longitude {
            _selectedCoordinate = State(initialValue: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
        _wantsToEditDate = State(initialValue: true)
        _selectedDate = State(initialValue: expense.date)
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Edit Expense".localized())) {
                    // Amount input field.
                    TextField("Amount".localized(), text: $amount)
                        .keyboardType(.decimalPad)

                    // Category picker.
                    Picker("Category".localized(), selection: $selectedCategory) {
                        ForEach(Category.allCases, id: \.self) { category in
                            Text(category.localizedName()).tag(category)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())

                    // Toggle for editing the date.
                    Toggle(isOn: $wantsToEditDate) {
                        Text("Edit Date?".localized())
                    }

                    // DatePicker shown if the toggle is on.
                    if wantsToEditDate {
                        DatePicker("Select Date".localized(), selection: $selectedDate, displayedComponents: .date)
                            .datePickerStyle(GraphicalDatePickerStyle())
                    }

                    // Toggle for editing the location.
                    Toggle(isOn: $wantsToEditLocation) {
                        Text("Edit Location?".localized())
                    }

                    // Button to select location if the toggle is on.
                    if wantsToEditLocation {
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

                    // Save changes button.
                    Button(action: {
                        saveChanges()
                    }) {
                        Text("Save".localized())
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .navigationBarTitle("Edit Expense".localized(), displayMode: .inline)
            .navigationBarItems(trailing: Button("Cancel".localized()) {
                presentationMode.wrappedValue.dismiss()
            })
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }

    // Saves the changes made to the expense.
    func saveChanges() {
        if let amountValue = Double(self.amount) {
            expense.amount = amountValue
            expense.category = selectedCategory.rawValue
            expense.date = wantsToEditDate ? selectedDate : expense.date
            if wantsToEditLocation {
                expense.latitude = selectedCoordinate?.latitude
                expense.longitude = selectedCoordinate?.longitude
            } else {
                expense.latitude = nil
                expense.longitude = nil
            }
            viewModel.updateExpense(expense: expense)
            presentationMode.wrappedValue.dismiss()
        }
    }
}

// Preview provider for EditExpenseView.
struct EditExpenseView_Previews: PreviewProvider {
    static var previews: some View {
        EditExpenseView(viewModel: LogsViewModel(), expense: Expense(amount: 50.0, category: "food", date: Date(), userID: "testUserID", latitude: nil, longitude: nil))
    }
}
