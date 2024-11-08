//
//  CharactersService.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct CharactersService: HTTPClient, EntityServiceable{
    typealias Entity = Character
    
    var sortSelection: SortSelection
    
    init(sortSelection: SortSelection = .popular) {
        self.sortSelection = sortSelection
    }
    
    var endpointForAll: Endpoint{
        return CharactersEndpoint.characters(sortSelection: sortSelection)
    }
    
    func endpointForId(_ id: Int) -> any Endpoint {
        return CharactersEndpoint.characterId(id: id)
    }
    
    func getPopularIds() -> [Int]? {
        return getPopularDataIds()?.characterIds
    }
}
