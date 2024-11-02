//
//  CharactersEndpoint.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

enum CharactersEndpoint{
    case characters
    case characterId(id: Int)
}

extension CharactersEndpoint: Endpoint{
    var path: String{
        switch self{
        case .characters:
            return "/v1/public/characters"
        case .characterId(let id):
            return "/v1/public/characters/\(id)"
        }
    }
}
