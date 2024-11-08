//
//  ComicsEndpoint.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

enum ComicsEndpoint{
    case comics(sortSelection: SortSelection?, offset: Int, limit: Int)
    case comicId(id: Int)
}

extension ComicsEndpoint: Endpoint{
    var sortSelection: SortSelection? {
        switch self {
        case .comics(let sort, _, _):
            return sort
        case .comicId:
            return nil
        }
    }
    
    var path: String{
        switch self{
        case .comics:
            return "/v1/public/comics"
        case .comicId(let id):
            return "/v1/public/comics/\(id)"
        }
    }
    
    var offset: Int {
        switch self {
        case .comics(_, let offset, _):
            return offset
        default:
            return 0
        }
    }
    
    var limit: Int {
        switch self {
        case .comics(_, _, let limit):
            return limit
        default:
            return 20
        }
    }
    
    static func increaseOffsetForEndpoint(endpoint: ComicsEndpoint) -> ComicsEndpoint {
        switch endpoint {
        case .comics(let sortSelection, let offset, let limit):
            return .comics(sortSelection: sortSelection, offset: offset + limit, limit: limit)
        default:
            return endpoint
        }
    }
}

