//
//  NumericaApp.swift
//  Numerica
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import SwiftUI
import SwiftData

@main
struct NumericaApp: App {

    var body: some Scene {
        WindowGroup {
            MainView()
                .environmentObject(
                    MainViewModel(
                        storageService: StorageService(
                            modelContext: sharedModelContainer.mainContext
                        ),
                        mathGen: ProblemGenerator()
                    )
                )
        }
    }
}
