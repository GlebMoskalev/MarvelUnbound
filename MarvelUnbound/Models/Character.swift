//
//  Character.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

typealias CharactersResponse = BaseResponse<Character>

struct Character: Codable {
    let id: Int
    let name, description: String
    let modified: String
    let thumbnail: Thumbnail
    let resourceURI: String
    let comics, series: ResourceCollection<ResourceItem>
    let stories: ResourceCollection<StoriesItem>
    let events: ResourceCollection<ResourceItem>
    let urls: [URLElement]
}
