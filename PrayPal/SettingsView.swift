import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @Environment(PrayerManager.self) private var prayerManager

    @AppStorage("menuBarLabelMode") private var labelMode: MenuBarLabelMode = .mosqueWithCountdown
    @AppStorage("calculationMethod") private var calculationMethodRaw: Int = CalculationMethod.egyptian.rawValue
    @AppStorage("notificationsEnabled") private var notificationsEnabled = false
    @AppStorage("notificationSound") private var notificationSound: NotificationSound = .defaultSound
    @State private var launchAtLogin = false

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
                        prayerManager.scheduleNotifications()
                    }

                Picker("Notification Sound", selection: $notificationSound) {
                    ForEach(NotificationSound.allCases) { sound in
                        Text(sound.rawValue).tag(sound)
                    }
                }
                .disabled(!notificationsEnabled)
                .onChange(of: notificationSound) { _, _ in
                    prayerManager.scheduleNotifications()
                }
            }

            Section("General") {
                Toggle("Launch at Login", isOn: $launchAtLogin)
                    .onChange(of: launchAtLogin) { _, newValue in
                        setLaunchAtLogin(newValue)
                    }
            }
        }
        .formStyle(.grouped)
        .onAppear {
            launchAtLogin = SMAppService.mainApp.status == .enabled
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
