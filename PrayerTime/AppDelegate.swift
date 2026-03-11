import AppKit
import CoreText

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    let prayerManager = PrayerManager.main
    let quranManager = QuranManager.shared
    let userDefaults = UserDefaults.standard

    func applicationDidFinishLaunching(_ notification: Notification) {
        registerCustomFonts()

        if userDefaults.object(forKey: .calculationMethod) == nil {
            userDefaults
                .set(
                    CalculationMethod.egyptian.rawValue,
                    forKey: .calculationMethod
                )
        }

        Task { await setupMethod() }
        prayerManager.startCountdownTimer()
        prayerManager.scheduleMidnightRefresh()
    }

    func applicationWillTerminate(_ notification: Notification) {
        prayerManager.cancelPrayerTasks()
    }

    private func registerCustomFonts() {
        let fontNames = ["Hafs", "AmiriQuran-Regular"]
        for fontName in fontNames {
            guard let url = Bundle.main.url(forResource: fontName, withExtension: "ttf") else { continue }
            CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
        }
    }

    private func setupMethod() async {
        await withTaskGroup { group in
            group.addTask { await self.prayerManager.requestNotificationPermission() }
            group.addTask { await self.prayerManager.fetchPrayerTimes() }
            group.addTask { await self.quranManager.fetchRandomAyah() }
        }
    }
}
