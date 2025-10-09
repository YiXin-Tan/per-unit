//
//  per_unitApp.swift
//  per-unit
//
//  Created by yixin on 19/09/2025.
//

import SwiftUI

@main
struct per_unitApp: App {
    @StateObject private var dataController = DataController()

    var body: some Scene {
        WindowGroup {
            NavigationTabView()
                .environment(\.managedObjectContext, dataController.container.viewContext) // live work with data in memory
        }
    }
}
