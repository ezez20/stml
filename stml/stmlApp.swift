//
//  stmlApp.swift
//  stml
//
//  Created by Ezra Yeoh on 6/15/23.
//

import SwiftUI

@main
struct stmlApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
