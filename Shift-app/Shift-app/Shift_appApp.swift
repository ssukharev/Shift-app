//
//  Shift_appApp.swift
//  Shift-app
//
//  Created by Suharev Sergey on 13.10.2025.
//

import SwiftUI

@main
struct Shift_appApp: App {
    let persistenceController = PersistenceController.shared
    
    @State private var isUserRegistered = UserStorageService.shared.isUserRegistered()

    var body: some Scene {
        WindowGroup {
            if isUserRegistered {
                MainView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                RegistrationView()
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            }
        }
    }
}
