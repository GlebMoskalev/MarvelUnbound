//
//  CharactersEndpoint.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

enum CharactersEndpoint{
    case characters(sortSelection: SortSelection?, offset: Int, limit: Int)
    case characterId(id: Int)
    case comicsForCharacter(characterId: Int, offset: Int, limit: Int)
}

extension CharactersEndpoint: Endpoint{
    var path: String{
        switch self{
        case .characters:
            return "/v1/public/characters"
        case .characterId(let id):
            return "/v1/public/characters/\(id)"
        case .comicsForCharacter(let characterId, _, _):
            return "/v1/public/characters/\(characterId)/comics"
        }
    }
    
    var sortSelection: SortSelection? {
        switch self {
        case .characters(let sort, _, _):
            return sort
        default:
            return nil
        }
    }
    
    var offset: Int {
        switch self {
        case .characters(_, let offset, _):
            return offset
        case .comicsForCharacter(_, let offset, _):
            return offset
        default:
            return 0
        }
    }
    
    var limit: Int {
        switch self {
        case .characters(_, _, let limit):
            return limit
        default:
            return 20
        }
    }
    
    static func increaseOffsetForEndpoint(endpoint: CharactersEndpoint) -> CharactersEndpoint {
        switch endpoint {
        case .characters(let sortSelection, let offset, let limit):
            return .characters(sortSelection: sortSelection, offset: offset + limit, limit: limit)
        case .comicsForCharacter(let charcterId, let offset, let limit):
            return .comicsForCharacter(characterId: charcterId, offset: offset + limit, limit: limit)
        default:
            return endpoint
        }
    }
}
