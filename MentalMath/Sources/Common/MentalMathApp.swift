//
//  MentalMathApp.swift
//  MentalMath
//
//  Created by Dmitry Aksyonov on 31.08.2024.
//

import SwiftUI
import SwiftData

@main
struct MentalMathApp: App {

    var body: some Scene {
        WindowGroup {
            GameView()
                .environmentObject(
                    GameViewModel(
                        storageService: StorageService(
                            modelContext: sharedModelContainer.mainContext
                        ),
                        mathGen: MathGen()
                    )
                )
        }
    }
}
