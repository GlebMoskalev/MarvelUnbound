//
//  CharacterDetailView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 01.12.2024.
//

import SwiftUI

struct CharacterDetailView: View {
    @Environment(\.dismiss) var dismiss
    @State var viewModel: CharacterDetailModel
    
    var body: some View {
        ScrollView{
            VStack(spacing: 0){
                CharacterImageView(imageURL: viewModel.imageURL)
                CharacterNameView(nameParts: viewModel.nameParts)
                CharacterDescriptionView(description: viewModel.description)
                CharacterComicsListView(
                    comics: $viewModel.comics,
                    isNoComics: $viewModel.isNoComics,
                    isLoadingMoreComics: $viewModel.isLoadingMoreComics,
                    isAllComicsUploaded: $viewModel.isAllComicsUploaded,
                    loadMoreAction: {
                        viewModel.isLoadingMoreComics = true
                        Task(priority: .high){
                            await viewModel.loadComics()
                            viewModel.isLoadingMoreComics = false
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
                await viewModel.loadComics(refresh: true)
            }
        }
        .onChange(of: viewModel.isLoadingMoreComics){
            print("isLoadingMoreComics \(viewModel.isLoadingMoreComics)")
        }
        .onChange(of: viewModel.isAllComicsUploaded){
            print("isAllComicsUploaded \(viewModel.isAllComicsUploaded)")
        }
        .onChange(of: viewModel.isNoComics){
            print("isAllComicsUploaded \(viewModel.isNoComics)")
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
                        ComicForCharacterDetailView(comic: comic)
                    }
                    if isNoComics && comics.isEmpty{
                        Text("This character has not appeared in the comics.")
                            .font(Font.customFont(.inter, style: .light, size: 15))
                    } else if !isLoadingMoreComics && !comics.isEmpty && !isAllComicsUploaded{
                        Button(action: loadMoreAction){
                            Text("Load More")
                                .foregroundStyle(.white)
                                .font(Font.customFont(.inter, style: .medium, size: 15))
                                .padding(.horizontal, 15)
                                .padding(.vertical, 9)
                                .background(.black)
                                .clipShape(RoundedRectangle(cornerRadius: 15))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
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
                        CharacterDetailView(viewModel: CharacterDetailModel(character: character, charactersService: CharactersService()))
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
