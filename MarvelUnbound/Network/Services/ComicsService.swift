//
//  ComicsService.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct ComicsService: HTTPClient, EntityServiceable{
    typealias Entity = Comic
    
    var endpointForAll: Endpoint{
        return ComicsEndpoint.comics
    }
    
    func endpointForId(_ id: Int) -> any Endpoint {
        return ComicsEndpoint.comicId(id: id)
    }
}
