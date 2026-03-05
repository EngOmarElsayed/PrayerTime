import SwiftUI

@main
struct PrayPalApp: App {
    @State private var prayerManager = PrayerManager.main
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra {
            PrayerListView()
                .environment(prayerManager)
        } label: {
            MenuBarLabelView()
                .environment(prayerManager)
        }
        .menuBarExtraStyle(.window)
    }
}
