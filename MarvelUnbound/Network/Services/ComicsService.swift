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
    
    init(sortSelection: SortSelection = .popular) {
        self.sortSelection = sortSelection
    }
    
    
    var endpointForAll: Endpoint{
        return ComicsEndpoint.comics(sortSelection: sortSelection)
    }
    
    func endpointForId(_ id: Int) -> any Endpoint {
        return ComicsEndpoint.comicId(id: id)
    }
    
    func getPopularIds() -> [Int]? {
        return getPopularDataIds()?.comicIds
    }
}
