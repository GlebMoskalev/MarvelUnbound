//
//  ComicForCharacterDetailView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 08.11.2024.
//

import SwiftUI

struct ComicForCharacterDetailView: View {
    let comic: Comic
    var body: some View {
        VStack(spacing: 0){
            if let thumbnail = comic.images.first{
                AsyncImage(url: URL(string: thumbnail.path + "/portrait_xlarge." + thumbnail.thumbnailExtension)) { image in
                    image
                } placeholder: {
                    LoadingView(sizeText: 10)
                }
            }
            
            Text(comic.title)
                .font(Font.customFont(.inter, style: .regular, size: 8))
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(maxWidth: 150)
    }
}

private struct ComicForCharacterDetail_Preview: View {
    let comicsService = ComicsService()
    @State var comic: Comic?
    
    var body: some View {
        VStack{
            if let comic = comic {
                ComicForCharacterDetailView(comic: comic)
            } else {
                Text("Loading")
            }
        }
        .task {
            await getCharacter()
        }
    }
    
    func getCharacter() async {
        let response = await comicsService.getEntityById(id: 16926)
        switch response{
        case .success(let responseCharacter):
            comic = responseCharacter.data.results.first
        case .failure(let e):
            comic = nil
            print(e)
        }
    }
}

#Preview {
    ComicForCharacterDetail_Preview()
}
