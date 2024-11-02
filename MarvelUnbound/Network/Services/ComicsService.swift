//
//  ComicsService.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

protocol ComicsServiceable{
    func getComicId(id: Int) async -> Swift.Result<ComicsResponse, RequestError>
    func getComics() async -> Swift.Result<ComicsResponse, RequestError>
}

struct ComicsService: HTTPClient, ComicsServiceable{
    func getComicId(id: Int) async -> Swift.Result<ComicsResponse, RequestError> {
        return await sendRequest(endpoint: ComicsEndpoint.comicId(id: id), responseModel: ComicsResponse.self)
    }
    
    func getComics() async -> Swift.Result<ComicsResponse, RequestError> {
        return await sendRequest(endpoint: ComicsEndpoint.comics, responseModel: ComicsResponse.self)
    }
}
