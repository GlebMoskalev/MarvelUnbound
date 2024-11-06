//
//  EventsServiceable.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct EventsService: HTTPClient, EntityServiceable{
    typealias Entity = Event
    
    var endpointForAll: Endpoint{
        return EventsEndpoint.events
    }
    
    func endpointForId(_ id: Int) -> any Endpoint {
        return EventsEndpoint.eventId(id: id)
    }
}
