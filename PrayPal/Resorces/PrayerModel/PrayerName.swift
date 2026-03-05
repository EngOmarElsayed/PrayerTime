//
//  PrayerName.swift
//  PrayPal
//
//  Created by Omar Elsayed on 04/03/2026.
//

import Foundation

enum PrayerName: String, CaseIterable, Identifiable {
    case fajr = "Fajr"
    case sunrise = "Sunrise"
    case dhuhr = "Dhuhr"
    case asr = "Asr"
    case maghrib = "Maghrib"
    case isha = "Isha"

    var id: String { rawValue }

    var emoji: String {
        switch self {
        case .fajr: return "🌅"
        case .sunrise: return "☀️"
        case .dhuhr: return "🌤️"
        case .asr: return "⛅"
        case .maghrib: return "🌇"
        case .isha: return "🌙"
        }
    }
}
