//
//  ComicForCharacterDetailModel.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.12.2024.
//

import SwiftUI

@Observable
class ComicForCharacterDetailViewModel{
    var imageURL: URL?
    var title: String
    
    private var comic: Comic
    
    init(comic: Comic) {
        self.comic = comic
        imageURL = URL(string: comic.thumbnail.path + "/portrait_xlarge." + comic.thumbnail.thumbnailExtension)
        title = comic.title
    }
}
