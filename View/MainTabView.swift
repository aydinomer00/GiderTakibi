//
//  MainTabView.swift
//  ExpenseTracker
//
//  Created by Omer Murat Aydin on 20.10.2024.
//

import SwiftUI

// The MainTabView contains the main tabs of the application.
struct MainTabView: View {
    @EnvironmentObject var languageManager: LanguageManager
    
    var body: some View {
        TabView {
            // Dashboard Tab.
            DashboardView()
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("dashboard".localized())
                }

            // Logs Tab.
            LogsView()
                .tabItem {
                    Image(systemName: "list.bullet")
                    Text("logs".localized())
                }

            // Map Tab.
            ExpensesMapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("map".localized())
                }

            // Settings Tab.
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("settings".localized())
                }
        }
    }
}

// Preview provider for MainTabView.
struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
            .environmentObject(SessionStore())
            .environmentObject(LanguageManager.shared)
    }
}

