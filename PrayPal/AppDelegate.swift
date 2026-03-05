import AppKit

@MainActor
final class AppDelegate: NSObject, NSApplicationDelegate {
    let prayerManager = PrayerManager.main
    let userDefaults = UserDefaults.standard

    func applicationDidFinishLaunching(_ notification: Notification) {
        if userDefaults.object(forKey: .calculationMethod) == nil {
            userDefaults
                .set(
                    CalculationMethod.egyptian.rawValue,
                    forKey: .calculationMethod
                )
        }

        Task {
            await prayerManager.requestNotificationPermission()
            await prayerManager.fetchPrayerTimes()
            prayerManager.startCountdownTimer()
            prayerManager.scheduleMidnightRefresh()
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        prayerManager.cancelPrayerTasks()
    }
}
