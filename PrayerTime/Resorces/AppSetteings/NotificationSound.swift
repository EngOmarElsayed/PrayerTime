//
//  NotificationSound.swift
//  PrayPal
//
//  Created by Omar Elsayed on 05/03/2026.
//

import Foundation

enum NotificationSound: String, CaseIterable, Identifiable {
    case defaultSound = "Default"
    case fullAdhan = "Full Adhan"
    case shortAdhan = "Short Adhan"

    var id: String { rawValue }

    var fileName: String? {
        switch self {
        case .defaultSound: return nil
        case .fullAdhan: return "full-adhan-sound"
        case .shortAdhan: return "short-adhan-sound"
        }
    }
}
