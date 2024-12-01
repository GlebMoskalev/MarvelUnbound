//
//  CharacterDetailModel.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 01.12.2024.
//

import Foundation

@Observable
class CharacterDetailModel{
    var comics: [Comic] = []
    var isLoadingMoreComics = false
    var isAllComicsUploaded = false
    var isNoComics = false
    var imageURL: URL?
    var nameParts: (String, String?)
    var description: String
    let character: Character
    private let charactersService: CharactersService
    
    init(character: Character, charactersService: CharactersService){
        self.character = character
        self.charactersService = charactersService
        
        imageURL = URL(string: character.thumbnail.path + "." + character.thumbnail.thumbnailExtension)
        
        let nameSplit = character.name.split(separator: "(")
        let firstPart = nameSplit[0].trimmingCharacters(in: .whitespaces)
        let secondPart = nameSplit.count > 1 ? String(nameSplit[1].dropLast()) : nil
        nameParts = (firstPart, secondPart)
        
        description = character.description.isEmpty ? "There is no description" : character.description
    }
    
    func loadComics(refresh: Bool = false) async{
        if refresh{
            charactersService.comicsOffset = 0
            comics = []
        } else{
            charactersService.increaseComicsOffset(forCharacterId: character.id)
        }
        let response = await charactersService.getComicsForCharacter(characterId: character.id)
        switch response {
        case .success(let success):
            isAllComicsUploaded = success.data.total <= (charactersService.comicsOffset  + charactersService.limit)
            print(isAllComicsUploaded, success.data.total, charactersService.comicsOffset)
            isNoComics = success.data.count == 0
            let newComics = success.data.results
            DispatchQueue.main.async {
                self.comics.append(contentsOf: newComics)
            }
        case .failure(let failure):
            DispatchQueue.main.async {
                self.comics = []
            }
            print(failure)
        }
    }
}
