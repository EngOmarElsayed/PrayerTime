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

enum MenuBarLabelMode: String, CaseIterable, Identifiable {
    case iconOnly = "Icon Only"
    case mosqueWithCountdown = "Icon + Countdown"
    case prayerNameWithCountdown = "Prayer Name + Countdown"

    var id: String { rawValue }
}

enum CalculationMethod: Int, CaseIterable, Identifiable {
    case jafari = 0
    case karachi = 1
    case isna = 2
    case mwl = 3
    case makkah = 4
    case egyptian = 5
    case tehran = 7
    case gulf = 8
    case kuwait = 9
    case qatar = 10
    case singapore = 11
    case france = 12
    case turkey = 13
    case russia = 14
    case moonsighting = 15
    case dubai = 16
    case jakim = 17
    case tunisia = 18
    case algeria = 19
    case kemenag = 20
    case morocco = 21
    case portugal = 22
    case jordan = 23

    var id: Int { rawValue }

    var label: String {
        switch self {
        case .jafari: return "Jafari / Shia Ithna-Ashari"
        case .karachi: return "University of Islamic Sciences, Karachi"
        case .isna: return "Islamic Society of North America"
        case .mwl: return "Muslim World League"
        case .makkah: return "Umm Al-Qura University, Makkah"
        case .egyptian: return "Egyptian General Authority of Survey"
        case .tehran: return "Institute of Geophysics, University of Tehran"
        case .gulf: return "Gulf Region"
        case .kuwait: return "Kuwait"
        case .qatar: return "Qatar"
        case .singapore: return "Majlis Ugama Islam Singapura, Singapore"
        case .france: return "Union Organization Islamique de France"
        case .turkey: return "Diyanet İşleri Başkanlığı, Turkey"
        case .russia: return "Spiritual Administration of Muslims of Russia"
        case .moonsighting: return "Moonsighting Committee Worldwide"
        case .dubai: return "Dubai (experimental)"
        case .jakim: return "Jabatan Kemajuan Islam Malaysia (JAKIM)"
        case .tunisia: return "Tunisia"
        case .algeria: return "Algeria"
        case .kemenag: return "KEMENAG - Indonesia"
        case .morocco: return "Morocco"
        case .portugal: return "Comunidade Islamica de Lisboa"
        case .jordan: return "Ministry of Awqaf, Jordan"
        }
    }
}
