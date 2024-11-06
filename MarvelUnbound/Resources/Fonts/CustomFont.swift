//
//  CustomFont.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 06.11.2024.
//

import SwiftUI

enum CustomFonts: String{
    case bangers = "Bangers"
    case inter = "Inter"
    case roboto = "Roboto"
}

enum CustomFontStyle: String{
    case bold = "-Bold"
    case regular = "-Regular"
    case medium = "-Medium"
    case light = "-Light"
    case semiBold = "-SemiBold"
}

extension Font {
    static func customFont(_ font: CustomFonts, style: CustomFontStyle, size: CGFloat) -> Font {
        let fontName = font.rawValue + style.rawValue
        return Font.custom(fontName, size: size)
    }

    static let primaryCharacterName = Font.customFont(.inter, style: .bold, size: 30)
    static let secondaryCharacterName = Font.customFont(.inter, style: .medium, size: 17)
    static let descriptionCharacter = Font.customFont(.inter, style: .regular, size: 15)
    static let sectionTitle = Font.customFont(.inter, style: .semiBold, size: 20)
}
