//
//  EventEndpoint.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

enum EventsEndpoint{
    case events(sortSelection: SortSelection?, offset: Int, limit: Int)
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
        case .events(let sort, _, _):
            return sort
        case .eventId:
            return nil
        }
    }
    
    var offset: Int {
        switch self {
        case .events(_, let offset, _):
            return offset
        default:
            return 0
        }
    }
    
    var limit: Int {
        switch self {
        case .events(_, _, let limit):
            return limit
        default:
            return 20
        }
    }
    
    static func increaseOffsetForEndpoint(endpoint: EventsEndpoint) -> EventsEndpoint {
        switch endpoint {
        case .events(let sortSelection, let offset, let limit):
            return .events(sortSelection: sortSelection, offset: offset + limit, limit: limit)
        default:
            return endpoint
        }
    }
}
