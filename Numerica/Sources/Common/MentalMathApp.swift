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
            GameView()
                .environmentObject(
                    GameViewModel(
                        storageService: StorageService(
                            modelContext: sharedModelContainer.mainContext
                        ),
                        mathGen: ProblemGenerator()
                    )
                )
        }
    }
}
