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
}

struct AladhanTimings: Decodable {
    let Fajr: String
    let Sunrise: String
    let Dhuhr: String
    let Asr: String
    let Maghrib: String
    let Isha: String
}
