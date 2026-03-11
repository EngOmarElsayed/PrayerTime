import Foundation

struct QuranAyahSingleResponse: Decodable {
    let code: Int
    let status: String
    let data: QuranAyah
}

struct QuranAyah: Decodable {
    let number: Int
    let text: String
    let surah: QuranSurah
    let numberInSurah: Int
}

struct QuranSurah: Decodable {
    let number: Int
    let name: String
    let englishName: String
    let englishNameTranslation: String
    let numberOfAyahs: Int
}
