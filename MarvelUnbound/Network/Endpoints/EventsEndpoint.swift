//
//  EventEndpoint.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

enum EventsEndpoint{
    case events(sortSelection: SortSelection?)
    case eventId(id: Int)
}

extension EventsEndpoint: Endpoint{
    var path: String{
        switch self{
        case .events:
            return "/v1/public/events"
        case .eventId(let id):
            return "v1/public/events\(id)"
        }
    }
    
    var sortSelection: SortSelection? {
        switch self {
        case .events(let sort):
            return sort
        case .eventId:
            return nil
        }
    }
}
