//
//  ResourceCollection.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct ResourceCollection<T: Codable>: Codable {
    let available: Int
    let collectionURI: String
    let items: [T]
    let returned: Int
}
