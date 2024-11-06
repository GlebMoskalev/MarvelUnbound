//
//  Event.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct Event: Codable {
    let id: Int
    let title: String
    let description: String?
    let resourceURI: String
    let urls: [URLElement]
    let modified: String
    let start, end: String?
    let thumbnail: Thumbnail
    let creators: ResourceCollection<CreatorItem>
    let characters: ResourceCollection<ResourceItem>
    let stories: ResourceCollection<StoriesItem>
    let comics, series: ResourceCollection<ResourceItem>
    let next, previous: ResourceItem?
}

