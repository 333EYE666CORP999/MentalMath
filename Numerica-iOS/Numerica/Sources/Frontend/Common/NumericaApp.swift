import SwiftData
import SwiftUI

@main
struct NumericaApp: App {

    var body: some Scene {
        WindowGroup {
            MainView()
                .tint(.white)
//                .environmentObject(
//                    MainViewModel(
//                        storageService: StorageService(
//                            modelContext: sharedModelContainer.mainContext
//                        ),
//                        mathGen: ProblemGenerator()
//                    )
//                )
            // FIXME: - убрать через семантические цвета на ui
                .environment(\.colorScheme, .dark)
        }
    }
}
