//
//  DataContainer.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct DataContainer<T: Codable>: Codable {
    let offset, limit, total, count: Int
    let results: [T]
}
