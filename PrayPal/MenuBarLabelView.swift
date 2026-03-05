import SwiftUI

struct MenuBarLabelView: View {
    @Environment(PrayerManager.self) private var prayerManager
    @AppStorage("menuBarLabelMode") private var labelMode: MenuBarLabelMode = .mosqueWithCountdown

    var body: some View {
        switch labelMode {
        case .iconOnly:
            Text("📿")
        case .mosqueWithCountdown:
            Text("📿 \(prayerManager.countdown)")

        case .prayerNameWithCountdown:
            if let name = prayerManager.nextPrayer?.name {
                Text("\(name.rawValue) \(prayerManager.countdown)")
            } else {
                Text("📿 \(prayerManager.countdown)")
            }
        }
    }
}
