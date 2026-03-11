//
//  PrayerManager.swift
//  PrayPal
//
//  Created by Omar Elsayed on 04/03/2026.
//

import Foundation
import UserNotifications
import AVFoundation
internal import _LocationEssentials
import AppKit

@MainActor
@Observable
final class PrayerManager {
    static var main = PrayerManager()

    // UI States
    private(set) var prayers: [PrayerTime] = []
    private(set) var isAdhanPlaying: Bool = false
    private(set) var nextPrayer: PrayerTime?
    private(set) var countdown: String = "--:--:--"
    private(set) var errorMessage: String?
    private(set) var hijriDate: HijriDate?

    // Tasks
    private var countdownTask: Task<Void, Never>?
    private var midnightRefreshTask: Task<Void, Never>?
    private var waitingForAudioTask: Task<Void, Never>?

    // Private states
    private let userDefualts = UserDefaults.standard
    private let center = UNUserNotificationCenter.current()
    private let locationManager = LocationManager()
    private var currentAdhanSound: NSSound?
    private var calculationMethod: CalculationMethod {
        let raw = userDefualts.integer(forKey: .calculationMethod)
        return CalculationMethod(rawValue: raw) ?? .egyptian
    }
    
    private init() {}
}

// MARK: - Prayer Time
extension PrayerManager {
    func fetchPrayerTimes() async {
        do {
            let location = try await locationManager.requestLocation()
            let data = try await fetchFromAPI(latitude: location.latitude, longitude: location.longitude)
            parsePrayerTimes(data.timings)
            hijriDate = data.date.hijri
            await scheduleNotifications()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    /// Refreshes prayer times (e.g. at midnight or on demand)
    func refresh() async {
        await fetchPrayerTimes()
    }

    func cancelPrayerTasks() {
        midnightRefreshTask?.cancel()
        midnightRefreshTask = nil

        countdownTask?.cancel()
        countdownTask = nil
    }
}

// MARK: - Notifications
extension PrayerManager {
    func toggleNotification(newValue: Bool) async {
        if newValue {
            await requestNotificationPermission()
            await scheduleNotifications()
        } else {
            userDefualts.set(false, forKey: .notificationsEnabled)
            cancelAllNotifications()
        }
    }
    
    func notificationState() -> Bool {
        userDefualts.bool(forKey: .notificationsEnabled)
    }

    func rescheduleNotifications() {
        Task { await scheduleNotifications() }
    }
    
    func requestNotificationPermission() async {
        let notificationSettings = await center.notificationSettings()

        switch notificationSettings.authorizationStatus {
        case .notDetermined:
            let result = try? await center.requestAuthorization(options: [.alert, .badge, .criticalAlert, .sound])
            userDefualts.set(result, forKey: .notificationsEnabled)
        case .denied:
            NSWorkspace.shared.open(URL(string: "x-apple.systempreferences:com.apple.preference.notifications")!)
        case .authorized, .provisional:
            userDefualts.set(true, forKey: .notificationsEnabled)
            return
        @unknown default:
            fatalError("I new case to authorizationStatus was added")
        }
    }
    
    private func scheduleNotifications() async {
        cancelAllNotifications()
        guard userDefualts.bool(forKey: .notificationsEnabled) else { return }
        for prayer in prayers {
            async let _ = normalNotification(for: prayer)
            // Pre-adhan reminder 20 minutes before
            async let _ = twentyMintuesNotification(for: prayer)
        }
    }

    private func normalNotification(for prayer: PrayerTime) async {
        if prayer.name == .sunrise { return }
        if prayer.isPassed { return }
        
        let content = UNMutableNotificationContent()
        content.title = "Prayer Time"
        content.body = "\(prayer.name.emoji) It's time for \(prayer.name.rawValue)"

        let soundRaw = userDefualts.string(forKey: .notificationSound) ?? NotificationSound.defaultSound.rawValue
        let selectedSound = NotificationSound(rawValue: soundRaw) ?? .defaultSound
        if let fileName = selectedSound.fileName {
            content.sound = UNNotificationSound(named: UNNotificationSoundName(fileName + ".wav"))
        } else {
            content.sound = .defaultCritical
        }
        
        let components = Calendar.current.dateComponents([.hour, .minute, .second], from: prayer.time)
        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: "prayer-\(prayer.name.rawValue)",
            content: content,
            trigger: trigger
        )

        try? await center.add(request)
    }

    private func twentyMintuesNotification(for prayer: PrayerTime) async {
        if userDefualts.bool(forKey: .preAdhanReminderEnabled) {
            let reminderTime = prayer.time.addingTimeInterval(-20 * 60)
            guard reminderTime > Date() else { return }

            let reminderContent = UNMutableNotificationContent()
            reminderContent.title = "Prayer Reminder"
            reminderContent.body = "\(prayer.name.emoji) \(prayer.name.rawValue) is in 20 minutes"
            reminderContent.sound = .default

            let reminderComponents = Calendar.current.dateComponents([.hour, .minute, .second], from: reminderTime)
            let reminderTrigger = UNCalendarNotificationTrigger(dateMatching: reminderComponents, repeats: false)

            let reminderRequest = UNNotificationRequest(
                identifier: "pre-prayer-\(prayer.name.rawValue)",
                content: reminderContent,
                trigger: reminderTrigger
            )

            try? await center.add(reminderRequest)
        }
    }

    private func cancelAllNotifications() {
        let identifiers = PrayerName.allCases.flatMap {
            ["prayer-\($0.rawValue)", "pre-prayer-\($0.rawValue)"]
        }
        center.removePendingNotificationRequests(withIdentifiers: identifiers)
    }
}

// MARK: - Adhan Audio Playback
extension PrayerManager {
    func stopAdhan() {
        currentAdhanSound?.stop()
        currentAdhanSound = nil
        isAdhanPlaying = false

        waitingForAudioTask?.cancel()
        waitingForAudioTask = nil
    }
    
    private func playAdhan(for prayer: PrayerTime?) async {
        guard prayer?.name != .sunrise else { return }
        let soundRaw = userDefualts.string(forKey: .notificationSound) ?? NotificationSound.defaultSound.rawValue
        let selectedSound = NotificationSound(rawValue: soundRaw) ?? .defaultSound
        
        guard let fileName = selectedSound.fileName else { return }
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else { return }
        
        currentAdhanSound = NSSound(contentsOf: url, byReference: true)
        currentAdhanSound?.play()
        isAdhanPlaying = true
        waitingForAudioTask = Task {
            try? await Task.sleep(for: .seconds(currentAdhanSound?.duration ?? 0.0))
            isAdhanPlaying = false
        }
    }
}

// MARK: - Timers
extension PrayerManager {
    func scheduleMidnightRefresh() {
        midnightRefreshTask?.cancel()
        midnightRefreshTask = Task {
            while !Task.isCancelled {
                let now = Date()
                guard let midnight = Calendar.current.date(byAdding: .day, value: 1, to: Calendar.current.startOfDay(for: now)) else { break }
                let interval = midnight.timeIntervalSince(now) + 60 // 1 minute past midnight
                try? await Task.sleep(for: .seconds(interval))
                guard !Task.isCancelled else { break }
                await fetchPrayerTimes()
                await QuranManager.shared.fetchRandomAyah()
            }
        }
    }

    func startCountdownTimer() {
        countdownTask?.cancel()
        countdownTask = Task {
            let tickStream = AsyncStream<Void> { continuation in
                let timer = DispatchSource.makeTimerSource(queue: .main)
                timer.schedule(deadline: .now(), repeating: 1.0)
                timer.setEventHandler { continuation.yield() }
                continuation.onTermination = { _ in timer.cancel() }
                timer.resume()
            }
            for await _ in tickStream {
                guard !Task.isCancelled else { break }
                await updateCountdown()
            }
        }
    }
}

// MARK: - Helper Methods
private extension PrayerManager {
    func updateCountdown() async {
        nextPrayer = prayers.first { $0.time > .now }
        guard let next = nextPrayer else {
            countdown = "--:--:--"
            return
        }
        
        let remaining = next.time.timeIntervalSince(Date())
        if remaining <= 0 {
            await playAdhan(for: nextPrayer)
            countdown = "00:00"
            return
        }
        
        let hours = Int(remaining) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        let seconds = Int(remaining) % 60
        
        if hours > 0 {
            countdown = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
        } else {
            countdown = String(format: "%02d:%02d", minutes, seconds)
        }
    }
    
    func parseTime(_ timeString: String) -> Date {
        let today = Calendar.current.startOfDay(for: Date())
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"

        // API may return time with timezone offset like "05:03 (EET)", strip it
        let cleaned = timeString.components(separatedBy: " ").first ?? timeString
        if let time = formatter.date(from: cleaned) {
            let components = Calendar.current.dateComponents([.hour, .minute], from: time)
            return Calendar.current
                .date(
                    bySettingHour: components.hour ?? 0,
                    minute: components.minute ?? 0,
                    second: 0,
                    of: today
                ) ?? today
        }

        return today
    }

    func fetchFromAPI(latitude: Double, longitude: Double) async throws -> AladhanData {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let dateString = dateFormatter.string(from: Date())
        
        let method = calculationMethod.rawValue
        let urlString = "https://api.aladhan.com/v1/timings/\(dateString)?latitude=\(latitude)&longitude=\(longitude)&method=\(method)"
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        let response = try JSONDecoder().decode(AladhanResponse.self, from: data)
        return response.data
    }
    
    func parsePrayerTimes(_ timings: AladhanTimings) {
        prayers = [
            PrayerTime(name: .fajr, time: parseTime(timings.Fajr)),
            PrayerTime(name: .sunrise, time: parseTime(timings.Sunrise)),
            PrayerTime(name: .dhuhr, time: parseTime(timings.Dhuhr)),
            PrayerTime(name: .asr, time: parseTime(timings.Asr)),
            PrayerTime(name: .maghrib, time: parseTime(timings.Maghrib)),
            PrayerTime(name: .isha, time: parseTime(timings.Isha)),
        ]
    }
}
