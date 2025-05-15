import SwiftUI
import SwiftData

@main
struct SODAMApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([VisitedPlaceItem.self])
        let modelConfiguration = ModelConfiguration(schema: schema)
        return try! ModelContainer(for: schema, configurations: [modelConfiguration])
    }()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(sharedModelContainer)
    }
}
