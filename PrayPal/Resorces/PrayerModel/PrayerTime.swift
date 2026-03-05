//
//  PrayerTime.swift
//  PrayPal
//
//  Created by Omar Elsayed on 04/03/2026.
//

import Foundation

struct PrayerTime: Identifiable {
    let id = UUID()
    let name: PrayerName
    let time: Date
    var isPassed: Bool {
        Date() >= time
    }
}
