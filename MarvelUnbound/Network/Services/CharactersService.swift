//
//  CharactersService.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

@Observable
class CharactersService: HTTPClient, EntityServiceable{
    typealias Entity = Character
    
    var sortSelection: SortSelection
    var offset: Int = 0
    var comicsOffset: Int = 0
    var limit: Int = 20
    init(sortSelection: SortSelection = .popular) {
        self.sortSelection = sortSelection
    }
    
    var endpointForAll: Endpoint{
        return CharactersEndpoint.characters(sortSelection: sortSelection, offset: offset, limit: limit)
    }
    
    func endpointForId(_ id: Int) -> any Endpoint {
        return CharactersEndpoint.characterId(id: id)
    }
    
    func getPopularIds() -> [Int]? {
        return getPopularDataIds()?.characterIds
    }
    
    func getComicsForCharacter(characterId: Int) async -> Swift.Result<BaseResponse<Comic>, RequestError> {
        let endpoint = CharactersEndpoint.comicsForCharacter(characterId: characterId, offset: comicsOffset, limit: limit)
        return await sendRequest(endpoint: endpoint, responseModel: BaseResponse<Comic>.self)
    }

    
    func increaseOffset() {
        let currentEndpoint = CharactersEndpoint.characters(sortSelection: sortSelection, offset: offset, limit: limit)
        let updatedEndpoint = CharactersEndpoint.increaseOffsetForEndpoint(endpoint: currentEndpoint)
        
        if case let CharactersEndpoint.characters(_, newOffset, _) = updatedEndpoint {
            self.offset = newOffset
        }
    }
    
    func increaseComicsOffset(forCharacterId characterId: Int) {
        comicsOffset += limit
    }
}
