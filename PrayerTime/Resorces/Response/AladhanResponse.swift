//
//  AladhanResponse.swift
//  PrayPal
//
//  Created by Omar Elsayed on 04/03/2026.
//

import Foundation

struct AladhanResponse: Decodable {
    let data: AladhanData
}

struct AladhanData: Decodable {
    let timings: AladhanTimings
    let date: AladhanDate
}

struct AladhanDate: Decodable {
    let hijri: HijriDate
}

struct HijriDate: Decodable {
    let day: String
    let month: HijriMonth
    let year: String

    func formatted(language: IslamicDateLanguage) -> String {
        let monthName = language == .arabic ? month.ar : month.en
        return "\(day) \(monthName) \(year)"
    }
}

struct HijriMonth: Decodable {
    let number: Int
    let en: String
    let ar: String
}

struct AladhanTimings: Decodable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}
