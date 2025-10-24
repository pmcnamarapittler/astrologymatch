//
//  ZodiacUtils.swift
//  astrologymatch
//
//  Created by Anantika Mannby on 10/7/25.
//

import Foundation

enum ZodiacSign: String, CaseIterable {
    case aries = "Aries"
    case taurus = "Taurus"
    case gemini = "Gemini"
    case cancer = "Cancer"
    case leo = "Leo"
    case virgo = "Virgo"
    case libra = "Libra"
    case scorpio = "Scorpio"
    case sagittarius = "Sagittarius"
    case capricorn = "Capricorn"
    case aquarius = "Aquarius"
    case pisces = "Pisces"
    
    var symbol: String {
        switch self {
        case .aries: return "♈"
        case .taurus: return "♉"
        case .gemini: return "♊"
        case .cancer: return "♋"
        case .leo: return "♌"
        case .virgo: return "♍"
        case .libra: return "♎"
        case .scorpio: return "♏"
        case .sagittarius: return "♐"
        case .capricorn: return "♑"
        case .aquarius: return "♒"
        case .pisces: return "♓"
        }
    }
    
    var element: String {
        switch self {
        case .aries, .leo, .sagittarius: return "Fire"
        case .taurus, .virgo, .capricorn: return "Earth"
        case .gemini, .libra, .aquarius: return "Air"
        case .cancer, .scorpio, .pisces: return "Water"
        }
    }
}

struct ZodiacUtils {
    static func zodiacSign(from date: Date) -> ZodiacSign {
        let calendar = Calendar.current
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        switch (month, day) {
        case (3, 21...31), (4, 1...19):
            return .aries
        case (4, 20...30), (5, 1...20):
            return .taurus
        case (5, 21...31), (6, 1...20):
            return .gemini
        case (6, 21...30), (7, 1...22):
            return .cancer
        case (7, 23...31), (8, 1...22):
            return .leo
        case (8, 23...31), (9, 1...22):
            return .virgo
        case (9, 23...30), (10, 1...22):
            return .libra
        case (10, 23...31), (11, 1...21):
            return .scorpio
        case (11, 22...30), (12, 1...21):
            return .sagittarius
        case (12, 22...31), (1, 1...19):
            return .capricorn
        case (1, 20...31), (2, 1...18):
            return .aquarius
        case (2, 19...29), (3, 1...20):
            return .pisces
            
        default:
            return .aries
        }
    }
    
    /// Gets the zodiac sign name as a string
    static func zodiacSignName(from date: Date) -> String {
        return zodiacSign(from: date).rawValue
    }
    
    /// Gets the zodiac sign symbol
    static func zodiacSymbol(from date: Date) -> String {
        return zodiacSign(from: date).symbol
    }
    
    /// Gets the zodiac sign element
    static func zodiacElement(from date: Date) -> String {
        return zodiacSign(from: date).element
    }
    // Helper function for UI - returns index 0-11 for zodiac wheel positioning
    static func zodiacSignIndex(_ signName: String) -> Int {
        let signs: [String] = [
            "Aries", "Taurus", "Gemini", "Cancer",
            "Leo", "Virgo", "Libra", "Scorpio",
            "Sagittarius", "Capricorn", "Aquarius", "Pisces"
        ]
        return signs.firstIndex(of: signName) ?? 0
    }
    
    // Helper function for UI - converts sign name to emoji symbol
    static func zodiacEmoji(_ signName: String) -> String {
        guard let sign = ZodiacSign(rawValue: signName) else { return "⭐️" }
        return sign.symbol
    }
}
