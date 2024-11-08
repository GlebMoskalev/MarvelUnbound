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
    
    init(sortSelection: SortSelection = .popular) {
        self.sortSelection = sortSelection
    }
    
    var endpointForAll: Endpoint{
        return EventsEndpoint.events(sortSelection: sortSelection)
    }
    
    func endpointForId(_ id: Int) -> any Endpoint {
        return EventsEndpoint.eventId(id: id)
    }
    
    func getPopularIds() -> [Int]? {
        return getPopularDataIds()?.eventIds
    }
}
