import SwiftUI

struct PrayerListView: View {
    @Environment(PrayerManager.self) private var prayerManager
    @AppStorage(.showIslamicDate) private var showIslamicDate = true
    @AppStorage(.islamicDateLanguage) private var islamicDateLanguage: IslamicDateLanguage = .english

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            Divider()
            prayerListSection
            Divider()
            quranSection
            Divider()
            footerSection
        }
        .frame(width: 260)
    }

    private var quranSection: some View {
        ScrollView {
            QuranVerseSection()
        }
        .frame(height: 100)
        .padding(.vertical, 12)
    }

    private var headerSection: some View {
        HStack {
            Text("Prayer Times")
                .font(.headline)

            Spacer()

            if prayerManager.isAdhanPlaying {
                Button("Stop Adhan") { prayerManager.stopAdhan() }
            } else if showIslamicDate, let hijriDate = prayerManager.hijriDate {
                Text("• \(hijriDate.formatted(language: islamicDateLanguage))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }

    private var prayerListSection: some View {
        VStack(spacing: 2) {
            ForEach(prayerManager.prayers) { prayer in
                PrayerRow(prayer: prayer, isNext: prayerManager.nextPrayer?.name == prayer.name)
            }
        }
        .padding(.vertical, 6)
    }

    private var footerSection: some View {
        HStack {
            SettingsLink {
                Label("Settings", systemImage: "gear")
            }
            .buttonStyle(.plain)

            Spacer()

            Button {
                Task {
                    await prayerManager.refresh()
                }
            } label: {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.plain)
            .help("Refresh prayer times")

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}

struct PrayerRow: View {
    let prayer: PrayerTime
    let isNext: Bool
    @AppStorage(.use24HourFormat) private var use24HourFormat = false

    private var timeFormatter: DateFormatter {
        let f = DateFormatter()
        f.dateFormat = use24HourFormat ? "HH:mm" : "hh:mm a"
        return f
    }

    var body: some View {
        HStack {
            Text(prayer.name.emoji)
                .font(.body)

            Text(prayer.name.rawValue)
                .fontWeight(isNext ? .semibold : .regular)

            Spacer()

            Text(timeFormatter.string(from: prayer.time))
                .font(.system(.body, design: .monospaced))
                .foregroundStyle(isNext ? .primary : .secondary)

            if prayer.isPassed {
                Image(systemName: "checkmark.circle.fill")
                    .foregroundStyle(.green)
                    .font(.caption)
            } else if isNext {
                Image(systemName: "arrow.right.circle.fill")
                    .foregroundStyle(.blue)
                    .font(.caption)
            } else {
                Image(systemName: "circle")
                    .foregroundStyle(.secondary)
                    .font(.caption)
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 4)
        .background(isNext ? Color.accentColor.opacity(0.1) : Color.clear)
        .clipShape(RoundedRectangle(cornerRadius: 6))
        .padding(.horizontal, 4)
    }
}
