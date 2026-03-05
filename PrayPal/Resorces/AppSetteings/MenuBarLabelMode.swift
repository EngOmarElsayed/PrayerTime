//
//  MenuBarLabelMode.swift
//  PrayPal
//
//  Created by Omar Elsayed on 05/03/2026.
//

import Foundation

enum MenuBarLabelMode: String, CaseIterable, Identifiable {
    case iconOnly = "Icon Only"
    case mosqueWithCountdown = "Icon + Countdown"
    case prayerNameWithCountdown = "Prayer Name + Countdown"

    var id: String { rawValue }
}
