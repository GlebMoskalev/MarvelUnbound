//
//  ComicForCharacterDetailView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 08.11.2024.
//

import SwiftUI

struct ComicForCharacterDetailView: View {
    @State var viewModel: ComicForCharacterDetailViewModel
    var body: some View {
        VStack(spacing: 0){
            AsyncImage(url: viewModel.imageURL) { image in
                image
            } placeholder: {
                ZStack(alignment: .center){
                    UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 15)
                        .frame(width: 150, height: 225)
                    
                    LoadingView(sizeText: 10)
                }
            }
            
            Text(viewModel.title)
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
                ComicForCharacterDetailView(viewModel: ComicForCharacterDetailViewModel(comic: comic))
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
