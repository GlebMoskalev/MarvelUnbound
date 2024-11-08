//
//  SortSelection.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 08.11.2024.
//

import Foundation

enum SortSelection: String{
    case popular = "Popular"
    case alphabeticalAscending = "A-Z"
    case alphabeticalDescending = "Z-A"
    case lastModified = "Last Modified"
    case firstModified = "First Modified"
    
    var orderByValue: String{
        switch self{
        case .alphabeticalAscending:
            "name"
        case .alphabeticalDescending:
            "-name"
        case .lastModified:
            "-modified"
        case .firstModified:
            "modified"
        case .popular:
            ""
        }
    }
}
