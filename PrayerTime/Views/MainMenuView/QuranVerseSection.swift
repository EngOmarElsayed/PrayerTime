//
//  QuranVerseSection.swift
//  PrayerTime
//
//  Created by Omar Elsayed on 07/03/2026.
//

import SwiftUI

struct QuranVerseSection: View {
    @Environment(QuranManager.self) private var quranManager
    
    var body: some View {
        if let verse = quranManager.verse {
            VStack(spacing: 8) {
                Text("\("'' "+verse.arabicText+" ''")")
                    .font(.custom("Hafs", size: 12))
                    .multilineTextAlignment(.leading)
                    .environment(\.layoutDirection, .rightToLeft)
                    .lineSpacing(8)
                
                Text("— \(verse.surahEnglishName) - \(verse.ayahNumber)")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
}
