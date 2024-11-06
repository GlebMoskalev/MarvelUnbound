//
//  CharactersService.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct CharactersService: HTTPClient, EntityServiceable{
    typealias Entity = Character
    
    var endpointForAll: Endpoint{
        return CharactersEndpoint.characters
    }
    
    func endpointForId(_ id: Int) -> any Endpoint {
        return CharactersEndpoint.characterId(id: id)
    }
}
