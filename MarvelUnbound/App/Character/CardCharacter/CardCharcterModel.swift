//
//  CardCharcterViewModel.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 01.12.2024.
//

import SwiftUI

import SwiftUI

@Observable
class CardCharacterViewModel{
    var imageURL: URL?
    var nameParts: (String, String?)
    var description: String
    var comics: [String]
    var modifiedDate: String
    let character: Character
    let characterService: CharactersService
    
    init(character: Character, characterService: CharactersService){
        self.character = character
        self.characterService = characterService
        
        imageURL = URL(string: character.thumbnail.path + "/standard_xlarge." + character.thumbnail.thumbnailExtension)
        
        let nameSplit = character.name.split(separator: "(")
        let firstPart = nameSplit[0].trimmingCharacters(in: .whitespaces)
        let secondPart = nameSplit.count > 1 ? String(nameSplit[1].dropLast()) : nil
        nameParts = (firstPart, secondPart)
        
        description = character.description.isEmpty ? "There is no description" : character.description
        
        comics = character.comics.items.prefix(2).map { $0.name }
        
        modifiedDate = Self.formatData(character.modified)
    }
    
    private static func formatData(_ modified: String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let displayFormatter = DateFormatter()
        displayFormatter.dateFormat = "EEEE, MMM d, yyyy"
        
        if let date = dateFormatter.date(from: modified) {
            return displayFormatter.string(from: date)
        } else {
            return "Unknown date"
        }
    }
}
