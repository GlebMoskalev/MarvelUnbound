//
//  ComicsEndpoint.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

enum ComicsEndpoint{
    case comics(sortSelection: SortSelection?)
    case comicId(id: Int)
}

extension ComicsEndpoint: Endpoint{
    var sortSelection: SortSelection? {
        switch self {
        case .comics(let sort):
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
}

