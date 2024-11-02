//
//  CharactersService.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

protocol CharactersServiceable{
    func getCharacterId(id: Int) async -> Swift.Result<CharactersResponse, RequestError>
    func getCharacters() async -> Swift.Result<CharactersResponse, RequestError>
}

struct CharactersService: HTTPClient, CharactersServiceable{
    func getCharacterId(id: Int) async -> Swift.Result<CharactersResponse, RequestError> {
        return await sendRequest(endpoint: CharactersEndpoint.characterId(id: id), responseModel: CharactersResponse.self)
    }
    
    func getCharacters() async -> Swift.Result<CharactersResponse, RequestError> {
        return await sendRequest(endpoint: CharactersEndpoint.characters, responseModel: CharactersResponse.self)
    }
}
