//
//  NotificationSound.swift
//  PrayPal
//
//  Created by Omar Elsayed on 05/03/2026.
//

import Foundation

enum NotificationSound: String, CaseIterable, Identifiable {
    case defaultSound = "Default"
    case shortAdhan = "Short Adhan"

    var id: String { rawValue }

    var fileName: String? {
        switch self {
        case .defaultSound: return nil
        case .shortAdhan: return "short-adhan-sound"
        }
    }
}
