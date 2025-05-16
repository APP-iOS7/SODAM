import SwiftUI
import SwiftData

@main
struct SODAMApp: App {
    var container = try! ModelContainer(for: Schema([PlaceItem.self]))
    
    var body: some Scene {
        WindowGroup {
            ContentView()
              .environmentObject(UserLocation.shared)
        }
        .modelContainer(container)
    }
}
