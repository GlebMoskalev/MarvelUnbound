//
//  CharacterDetailView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 01.12.2024.
//

import SwiftUI

struct CharacterDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var model: CharacterDetailModel
    
    var body: some View {
        ScrollView{
            VStack(spacing: 0){
                CharacterImageView(imageURL: model.imageURL)
                CharacterNameView(nameParts: model.nameParts)
                CharacterDescriptionView(description: model.description)
                CharacterComicsListView(
                    comics: $model.comics,
                    isNoComics: $model.isNoComics,
                    isLoadingMoreComics: $model.isLoadingMoreComics,
                    isAllComicsUploaded: $model.isAllComicsUploaded,
                    loadMoreAction: {
                        model.isLoadingMoreComics = true
                        Task(priority: .high){
                            await model.loadComics()
                            model.isLoadingMoreComics = false
                        }
                    })
            }
            
            Spacer()
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading){
                Button{
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(.black)
                }
            }
        }
        .onAppear{
            Task(priority: .high){
                await model.loadComics(refresh: true)
            }
        }
    }
}

private struct CharacterComicsListView: View{
    @Binding var comics: [Comic]
    @Binding var isNoComics: Bool
    @Binding var isLoadingMoreComics: Bool
    @Binding var isAllComicsUploaded: Bool
    let loadMoreAction: () -> Void
    
    var body: some View{
        VStack(alignment: .leading){
            Text("Comics:")
                .font(Font.customFont(.inter, style: .semiBold, size: 20))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding([.leading, .top], 20)
            
            ScrollView(.horizontal, showsIndicators: false){
                HStack(spacing: 20){
                    ForEach(comics, id: \.id) { comic in
                        ComicForCharacterDetailView(model: ComicForCharacterDetailModel(comic: comic))
                    }
                    if isNoComics && comics.isEmpty{
                        Text("This character has not appeared in the comics.")
                            .font(Font.customFont(.inter, style: .light, size: 15))
                    } else if !isLoadingMoreComics && !comics.isEmpty && !isAllComicsUploaded{
                        LoadMoreButton(action: loadMoreAction)
                    } else if isAllComicsUploaded{
                        EmptyView()
                    } else{
                        LoadingView(sizeText: 10)
                    }
                }
                .padding(.horizontal, 20)
            }
        }
    }
}

private struct CharacterImageView: View {
    let imageURL: URL?
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFit()
        } placeholder: {
            LoadingView(sizeText: 30)
                .padding(.top, 100)
        }
    }
}

private struct CharacterDescriptionView: View {
    let description: String
    var body: some View {
        Text(description)
            .font(Font.customFont(.inter, style: .regular, size: 15))
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
    }
}

private struct CharacterNameView: View {
    let nameParts: (String, String?)
    
    var body: some View {
        VStack(spacing: 0){
            Text(nameParts.0)
                .font(Font.customFont(.inter, style: .bold, size: 30))
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if let secondPart = nameParts.1{
                Text(secondPart)
                    .font(Font.customFont(.inter, style: .medium, size: 17))
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
        .padding(.leading, 20)
    }
}


private struct CharacterDetail_Preview: View {
    let charactersService = CharactersService()
    @State var character: Character?
    
    var body: some View {
        VStack{
            if let character = character {
                NavigationStack{
                    NavigationLink{
                        CharacterDetailView(model: CharacterDetailModel(character: character, charactersService: CharactersService()))
                    } label: {
                        Text("transition detail")
                    }
                    
                }
            } else {
                Text("Loading")
            }
        }
        .task {
            await getCharacter()
        }
    }
    
    func getCharacter() async {
        let response = await charactersService.getEntityById(id: 1009187)
        switch response{
        case .success(let responseCharacter):
            character = responseCharacter.data.results.first
        case .failure(let e):
            character = nil
            print(e)
        }
    }
}

#Preview {
    CharacterDetail_Preview()
}
