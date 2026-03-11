import Foundation

struct QuranVerse: Codable {
    let arabicText: String
    let surahName: String
    let surahEnglishName: String
    let ayahNumber: Int

    init(from ayah: QuranAyah) {
        self.arabicText = ayah.text
        self.surahName = ayah.surah.name
        self.surahEnglishName = ayah.surah.englishName
        self.ayahNumber = ayah.numberInSurah
    }
}
