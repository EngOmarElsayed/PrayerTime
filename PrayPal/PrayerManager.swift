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

@MainActor
@Observable
final class PrayerManager {
    var prayers: [PrayerTime] = []
    var isAdhanPlaying: Bool = false
    var nextPrayer: PrayerTime?
    var countdown: String = "--:--:--"
    var errorMessage: String?
    
    private let locationManager = LocationManager()
    private var countdownTask: Task<Void, Never>?
    private var audioPlayer: AVAudioPlayer?
    
    var calculationMethod: CalculationMethod {
        let raw = UserDefaults.standard.integer(forKey: "calculationMethod")
        return CalculationMethod(rawValue: raw) ?? .egyptian
    }
    
    init() {
        // Set default calculation method if not already set
        if UserDefaults.standard.object(forKey: "calculationMethod") == nil {
            UserDefaults.standard.set(CalculationMethod.egyptian.rawValue, forKey: "calculationMethod")
        }
        Task {
            async let _ =  requestNotificationPermission()
            async let _ = fetchPrayerTimes()
            startCountdownTimer()
        }
    }
}

// MARK: - Prayer Time
extension PrayerManager {
    func fetchPrayerTimes() async {
        do {
            let location = try await locationManager.requestLocation()
            let timings = try await fetchFromAPI(latitude: location.latitude, longitude: location.longitude)
            parsePrayerTimes(timings)
            updateCountdown()
            scheduleNotifications()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
            // Use default location (Mecca) as fallback
            do {
                let timings = try await fetchFromAPI(latitude: 21.4225, longitude: 39.8262)
                parsePrayerTimes(timings)
                updateCountdown()
                scheduleNotifications()
            } catch {
                errorMessage = "Failed to load prayer times"
            }
        }
    }
    
    /// Refreshes prayer times (e.g. at midnight or on demand)
    func refresh() async {
        await fetchPrayerTimes()
    }
}

// MARK: - Notifications
extension PrayerManager {
    func requestNotificationPermission() async {
        #warning("Handle notification authorization")
        _ = try? await UNUserNotificationCenter.current().requestAuthorization()
    }
    
    func scheduleNotifications() {
        let center = UNUserNotificationCenter.current()
        // Remove previously scheduled prayer notifications
        center
            .removePendingNotificationRequests(
                withIdentifiers:
                    PrayerName.allCases
                    .map {
                        "prayer-\($0.rawValue)"
                    }
        )

        let notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        guard notificationsEnabled else { return }
        for prayer in prayers {
            if prayer.name == .sunrise { continue }
            if prayer.isPassed { continue }
            
            let content = UNMutableNotificationContent()
            content.title = "Prayer Time"
            content.body = "\(prayer.name.emoji) It's time for \(prayer.name.rawValue)"
            content.sound = .default
            
            let components = Calendar.current.dateComponents([.hour, .minute, .second], from: prayer.time)
            let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
            
            let request = UNNotificationRequest(
                identifier: "prayer-\(prayer.name.rawValue)",
                content: content,
                trigger: trigger
            )
            center.add(request)
        }
    }
}

// MARK: - Adhan Audio Playback
extension PrayerManager {
    func stopAdhan() {
        audioPlayer?.stop()
        audioPlayer = nil
        isAdhanPlaying = false
    }
    
    private func playAdhan() {
        let soundRaw = UserDefaults.standard.string(forKey: "notificationSound") ?? NotificationSound.defaultSound.rawValue
        let selectedSound = NotificationSound(rawValue: soundRaw) ?? .defaultSound
        
        guard let fileName = selectedSound.fileName else { return }
        guard let url = Bundle.main.url(forResource: fileName, withExtension: "wav") else { return }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            isAdhanPlaying = true
        } catch {
            // Playback failed
        }
    }
}

// MARK: - Helper Methods
private extension PrayerManager {
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
                updateCountdown()
            }
        }
    }
    
    func updateCountdown() {
        nextPrayer = prayers.first { $0.time > .now }
        guard let next = nextPrayer else {
            countdown = "--:--"
            return
        }
        
        let remaining = next.time.timeIntervalSince(Date())
        if remaining <= 0 {
            playAdhan()
            countdown = "00:00"
            return
        }
        
        let hours = Int(remaining) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        let seconds = Int(remaining) % 60
        
        if hours > 0 {
            countdown = String(format: "%d:%02d:%02d", hours, minutes, seconds)
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

    func fetchFromAPI(latitude: Double, longitude: Double) async throws -> AladhanTimings {
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
        return response.data.timings
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
