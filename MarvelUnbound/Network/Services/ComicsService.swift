//
//  ComicsService.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct ComicsService: HTTPClient, EntityServiceable{
    typealias Entity = Comic
    
    var sortSelection: SortSelection
    private var offset: Int = 0
    private var limit: Int = 20
    
    init(sortSelection: SortSelection = .popular) {
        self.sortSelection = sortSelection
    }
    
    
    var endpointForAll: Endpoint{
        return ComicsEndpoint.comics(sortSelection: sortSelection, offset: offset, limit: limit)
    }
    
    func endpointForId(_ id: Int) -> any Endpoint {
        return ComicsEndpoint.comicId(id: id)
    }
    
    func getPopularIds() -> [Int]? {
        return getPopularDataIds()?.comicIds
    }
    
    mutating func increaseOffset() {
        let currentEndpoint = ComicsEndpoint.comics(sortSelection: sortSelection, offset: offset, limit: limit)
        let updatedEndpoint = ComicsEndpoint.increaseOffsetForEndpoint(endpoint: currentEndpoint)
        
        if case let ComicsEndpoint.comics(_, newOffset, _) = updatedEndpoint {
            self.offset = newOffset
        }
    }
}
