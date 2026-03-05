//
//  IslamicDateLanguage.swift
//  PrayPal
//
//  Created by Omar Elsayed on 05/03/2026.
//

import Foundation

enum IslamicDateLanguage: String, CaseIterable, Identifiable {
    case english = "English"
    case arabic = "Arabic"

    var id: String { rawValue }
}
