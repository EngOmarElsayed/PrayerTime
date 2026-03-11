import SwiftUI
import ServiceManagement
import StoreKit

struct SettingsView: View {
    @Environment(PrayerManager.self) private var prayerManager
    @Environment(\.requestReview) private var requestReview

    @AppStorage(.menuBarLabelMode) private var labelMode: MenuBarLabelMode = .mosqueWithCountdown
    @AppStorage(.calculationMethod) private var calculationMethodRaw: Int = CalculationMethod.egyptian.rawValue
    @AppStorage(.notificationSound) private var notificationSound: NotificationSound = .defaultSound
    @AppStorage(.use24HourFormat) private var use24HourFormat = false
    @AppStorage(.showIslamicDate) private var showIslamicDate = true
    @AppStorage(.islamicDateLanguage) private var islamicDateLanguage: IslamicDateLanguage = .english
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled
    @AppStorage(.preAdhanReminderEnabled) private var preAdhanReminder = false
    @State private var notificationsEnabled = false

    private var calculationMethod: Binding<CalculationMethod> {
        Binding(
            get: { CalculationMethod(rawValue: calculationMethodRaw) ?? .egyptian },
            set: { newValue in
                calculationMethodRaw = newValue.rawValue
                Task {
                    await prayerManager.refresh()
                }
            }
        )
    }

    var body: some View {
        Form {
            Section("Menu Bar Label") {
                Picker("Display Mode", selection: $labelMode) {
                    ForEach(MenuBarLabelMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.radioGroup)
            }

            Section("Calculation Method") {
                Picker("Method", selection: calculationMethod) {
                    ForEach(CalculationMethod.allCases) { method in
                        Text(method.label).tag(method)
                    }
                }
            }

            Section("Notifications") {
                Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    .onChange(of: notificationsEnabled) { _, _ in
                        Task{ await prayerManager.toggleNotification(newValue: notificationsEnabled) }
                    }

                Picker("Notification Sound", selection: $notificationSound) {
                    ForEach(NotificationSound.allCases) { sound in
                        Text(sound.rawValue).tag(sound)
                    }
                }
                .disabled(!notificationsEnabled)

                Toggle("20-Minute Pre-Adhan Reminder", isOn: $preAdhanReminder)
                    .disabled(!notificationsEnabled)
                    .onChange(of: preAdhanReminder) { _, _ in
                        prayerManager.rescheduleNotifications()
                    }
            }

            Section("General") {
                Toggle("Show Islamic Date", isOn: $showIslamicDate)

                Picker("Islamic Date Language", selection: $islamicDateLanguage) {
                    ForEach(IslamicDateLanguage.allCases) { language in
                        Text(language.rawValue).tag(language)
                    }
                }
                .disabled(!showIslamicDate)

                Toggle("24-Hour Time Format", isOn: $use24HourFormat)

                Toggle("Launch at Login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, newValue in
                        setLaunchAtLogin(newValue)
                    }
            }

            Section {
                HStack {
                    Button {
                        requestReview()
                    } label: {
                        Label("Rate Us", systemImage: "star")
                    }

                    Spacer()

                    Button {
                        NSWorkspace.shared.open(URL(string: "https://www.prayer-time.app")!)
                    } label: {
                        Label("Visit Our Website", systemImage: "globe")
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 400)
        .onAppear {
            notificationsEnabled = prayerManager.notificationState()
            NSApp.activate(ignoringOtherApps: true)
        }
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        do {
            if enabled {
                try SMAppService.mainApp.register()
            } else {
                try SMAppService.mainApp.unregister()
            }
        } catch {
            // Revert toggle if registration fails
            launchAtLogin = SMAppService.mainApp.status == .enabled
        }
    }
}


// Transparent window
struct VisualEffectBackground: NSViewRepresentable {
    func makeNSView(context: Context) -> NSVisualEffectView {
        let view = NSVisualEffectView()
        view.material = .hudWindow
        view.blendingMode = .behindWindow
        view.state = .active
        return view
    }

    func updateNSView(_ nsView: NSVisualEffectView, context: Context) {}
}

