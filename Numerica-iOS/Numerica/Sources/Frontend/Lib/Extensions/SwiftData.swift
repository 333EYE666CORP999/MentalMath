import Foundation
import SwiftData

#warning("Global scope variable, use ONLY for previews")
let sharedModelContainer: ModelContainer = {
    let schema = Schema([GameSessionObject.self])
    let modelConfiguration = ModelConfiguration(
        schema: schema,
        isStoredInMemoryOnly: false
    )

    do {
        return try ModelContainer(
            for: schema,
            configurations: [modelConfiguration]
        )
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
