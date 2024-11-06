//
//  PopularData.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct PopularDataIds: Codable {
    let characterIds: [Int]
    let comicIds: [Int]
    let eventIds: [Int]
}

func getPopularDataIds() -> PopularDataIds? {
    if let path = Bundle.main.path(forResource: "popularData", ofType: "json") {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let popularData = try JSONDecoder().decode(PopularDataIds.self, from: data)
            return popularData
        } catch {
            return nil
        }
    }
    return nil
}
