import SwiftUI
import SwiftData

@main
struct SODAMApp: App {
    var container = try! ModelContainer(for: Schema([PlaceItem.self]))
    
    // 앱 시작 시 UserDefaults값 초기화 로직 호출
    init() {
        UserDefaultsManager.shared.setupDefaultsIfNeeded()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
