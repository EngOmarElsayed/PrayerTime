import Foundation

@MainActor
@Observable
final class QuranManager {
    static let shared = QuranManager()

    private(set) var verse: QuranVerse?
    private(set) var errorMessage: String?
    private let userDefaults = UserDefaults.standard

    private init() { loadCached() }
}

// MARK: - Public Methods
extension QuranManager {
    func fetchRandomAyah() async {
        guard let lastDate = userDefaults.object(forKey: .lastFetchDateKey) as? Date else { return }
        guard !Calendar.current.isDateInToday(lastDate) || verse == nil else { return }
        await fetchVerus()
    }
}

// MARK: - Private Methods
private extension QuranManager {
    private func loadCached() {
        guard let lastDate = userDefaults.object(forKey: .lastFetchDateKey) as? Date,
              Calendar.current.isDateInToday(lastDate),
              let data = userDefaults.data(forKey: .cachedVerseKey) else {
            return
        }
        verse = try? JSONDecoder().decode(QuranVerse.self, from: data)
    }

    private func saveToCache() {
        userDefaults.set(Date(), forKey: .lastFetchDateKey)
        let data = try? JSONEncoder().encode(verse)
        userDefaults.set(data, forKey: .cachedVerseKey)
    }
}

// MARK: - API Method
private extension QuranManager {
    func fetchVerus() async {
        do {
            let url = URL(string: "https://api.qurani.ai/gw/qh/v1/ayah/random")!
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try JSONDecoder().decode(QuranAyahSingleResponse.self, from: data)

            verse = QuranVerse(from: response.data)
            errorMessage = nil
            saveToCache()
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}
