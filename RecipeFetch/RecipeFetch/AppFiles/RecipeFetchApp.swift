//
//  RecipeFetchApp.swift
//  RecipeFetch
//
//  Created by Estelle Paus on 1/28/25.
//

import SwiftUI
import SwiftData

@main
struct RecipeFetchApp: App {
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RecipeScrollView()
        }
    }
}
