//
//  EventsServiceable.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct EventsService: HTTPClient, EntityServiceable{
    typealias Entity = Event
    
    var sortSelection: SortSelection
    private var offset: Int = 0
    private var limit: Int = 20
    
    init(sortSelection: SortSelection = .popular) {
        self.sortSelection = sortSelection
    }
    
    var endpointForAll: Endpoint{
        return EventsEndpoint.events(sortSelection: sortSelection, offset: offset, limit: limit)
    }
    
    func endpointForId(_ id: Int) -> any Endpoint {
        return EventsEndpoint.eventId(id: id)
    }
    
    func getPopularIds() -> [Int]? {
        return getPopularDataIds()?.eventIds
    }
    
    mutating func increaseOffset() {
        let currentEndpoint = EventsEndpoint.events(sortSelection: sortSelection, offset: offset, limit: limit)
        let updatedEndpoint = EventsEndpoint.increaseOffsetForEndpoint(endpoint: currentEndpoint)
        
        if case let EventsEndpoint.events(_, newOffset, _) = updatedEndpoint {
            self.offset = newOffset
        }
    }
}
