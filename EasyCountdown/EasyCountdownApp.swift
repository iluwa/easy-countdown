//
//  EasyCountdownApp.swift
//  EasyCountdown
//
//  Created by Ilia Koliaskin on 19/11/2024.
//

import SwiftUI

@main
struct EasyCountdownApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
