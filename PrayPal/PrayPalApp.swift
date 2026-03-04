import SwiftUI

@main
struct PrayPalApp: App {
    @State private var prayerManager = PrayerManager()
    @AppStorage("menuBarLabelMode") private var labelMode: MenuBarLabelMode = .mosqueWithCountdown

    var body: some Scene {
        MenuBarExtra {
            PrayerListView()
                .environment(prayerManager)
        } label: {
            MenuBarLabelView(
                mode: labelMode,
                countdown: prayerManager.countdown,
                nextPrayerName: prayerManager.nextPrayer?.name.rawValue
            )
        }
        .menuBarExtraStyle(.window)
    }
}
