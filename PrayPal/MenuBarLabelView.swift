import SwiftUI

struct MenuBarLabelView: View {
    let mode: MenuBarLabelMode
    let countdown: String
    let nextPrayerName: String?

    var body: some View {
        switch mode {
        case .iconOnly:
            Text("📿")
        case .mosqueWithCountdown:
            Text("📿 \(countdown)")
        case .prayerNameWithCountdown:
            if let name = nextPrayerName {
                Text("\(name) \(countdown)")
            } else {
                Text("📿 \(countdown)")
            }
        }
    }
}
