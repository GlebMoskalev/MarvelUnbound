//
//  ComicsEndpoint.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

enum ComicsEndpoint{
    case comics
    case comicId(id: Int)
}

extension ComicsEndpoint: Endpoint{
    var path: String{
        switch self{
        case .comics:
            return "/v1/public/comics"
        case .comicId(let id):
            return "/v1/public/comics/\(id)"
        }
    }
}

