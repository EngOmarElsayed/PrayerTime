import SwiftUI
import ServiceManagement

struct SettingsView: View {
    @Environment(PrayerManager.self) private var prayerManager

    @AppStorage(.menuBarLabelMode) private var labelMode: MenuBarLabelMode = .mosqueWithCountdown
    @AppStorage(.calculationMethod) private var calculationMethodRaw: Int = CalculationMethod.egyptian.rawValue
    @AppStorage(.notificationSound) private var notificationSound: NotificationSound = .defaultSound
    @State private var launchAtLogin = SMAppService.mainApp.status == .enabled
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
            notificationsEnabled = prayerManager.notificationState()
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
