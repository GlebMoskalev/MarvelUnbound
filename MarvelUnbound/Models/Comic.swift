//
//  Comic.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

struct Comic: Codable {
    let id, digitalID: Int
    let title: String
    let issueNumber: Double
    let variantDescription: String?  
    let description: String?
    let modified: String
    let isbn: String?
    let upc, diamondCode: String
    let ean: String?
    let issn: String?
    let format: String
    let pageCount: Int
    let textObjects: [TextObject]
    let resourceURI: String
    let urls: [URLElement]
    let series: ResourceItem
    let variants: [ResourceItem]
    let collections: [ResourceItem]
    let collectedIssues: [ResourceItem]
    let dates: [DateElement]
    let prices: [Price]
    let thumbnail: Thumbnail
    let images: [Thumbnail]
    let creators: ResourceCollection<CreatorItem>
    let characters: ResourceCollection<ResourceItem>
    let stories: ResourceCollection<StoriesItem>
    let events: ResourceCollection<ResourceItem>

    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title, issueNumber, variantDescription, description, modified
        case isbn, upc, diamondCode, ean, issn, format, pageCount
        case textObjects, resourceURI, urls, series, variants
        case collections, collectedIssues, dates, prices
        case thumbnail, images, creators, characters, stories, events
    }
}

struct CreatorItem: Codable {
    let resourceURI: String
    let name: String
    let role: String
}

struct DateElement: Codable {
    let type: String
    let date: String
}

struct Price: Codable {
    let type: String
    let price: Double
}

struct TextObject: Codable {
    let type: String
    let language: String
    let text: String
}
