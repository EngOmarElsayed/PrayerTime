import SwiftUI

@main
struct PrayPalApp: App {
    @State private var prayerManager = PrayerManager.main
    @State private var quranManager = QuranManager.shared
    @NSApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate

    var body: some Scene {
        MenuBarExtra {
            PrayerListView()
                .environment(prayerManager)
                .environment(quranManager)
        } label: {
            MenuBarLabelView()
                .environment(prayerManager)
        }
        .menuBarExtraStyle(.window)

        Settings {
            SettingsView()
                .environment(prayerManager)
        }
        .windowResizability(.contentSize)
        .defaultPosition(.center)
    }
}
