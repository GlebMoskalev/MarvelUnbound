//
//  CharacterDetailView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 08.11.2024.
//

import SwiftUI

struct CharacterDetailView: View {
    @Environment(\.dismiss) var dismiss
    let character: Character
    @State var comics: [Comic] = []
    @Binding var charactersService: CharactersService
    @State var isLoadingMoreComics = false
    @State var currentTaskForComics: Task<Void, Never>?
    @State var isAllComicsUploaded = false
    @State var isNoComics = false
    
    var body: some View {
        ScrollView{
            VStack(spacing: 0){
                AsyncImage(url: URL(string: character.thumbnail.path + "." + character.thumbnail.thumbnailExtension)) { image in
                    image
                        .resizable()
                        .scaledToFit()
                } placeholder: {
                    LoadingView(sizeText: 30)
                        .padding(.top, 100)
                }
                
                VStack(spacing: 0){
                    let nameSplit = character.name.split(separator: "(")
                    let firstPart = nameSplit[0].trimmingCharacters(in: .whitespaces)
                    Text(firstPart)
                        .font(Font.customFont(.inter, style: .bold, size: 30))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.top, 8)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    if nameSplit.count == 2{
                        let secondPart = String(nameSplit[1].dropLast())
                        Text(secondPart)
                            .font(Font.customFont(.inter, style: .medium, size: 17))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }
                }
                .padding(.leading, 20)
                
                Text(
                    character.description.isEmpty
                    ? "There is no description"
                    : character.description
                )
                .font(Font.customFont(.inter, style: .regular, size: 15))
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                
                Text("Comics:")
                    .font(Font.customFont(.inter, style: .semiBold, size: 20))
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding([.leading, .top], 20)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(spacing: 20){
                        ForEach(comics, id: \.id) { comic in
                            ComicForCharacterDetailView(comic: comic)
                        }
                        
                        if isNoComics{
                            Text("This character has not appeared in the comics.")
                                .font(Font.customFont(.inter, style: .light, size: 15))
                        } else if !isLoadingMoreComics && !comics.isEmpty && !isAllComicsUploaded{
                            Button{
                                isLoadingMoreComics = true
                                currentTaskForComics = Task(priority: .high){
                                    await loadComics()
                                    isLoadingMoreComics = false
                                }
                            } label: {
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
            currentTaskForComics = Task(priority: .high){
                await loadComics(refresh: true)
            }
        }
    }
    
    
    private func loadComics(refresh: Bool = false) async{
        if refresh{
            charactersService.comicsOffset = 0
            comics = []
        } else{
            charactersService.increaseComicsOffset(forCharacterId: character.id)
        }
        let response = await charactersService.getComicsForCharacter(characterId: character.id)
        switch response {
        case .success(let success):
            isAllComicsUploaded = success.data.total >= charactersService.comicsOffset
            isNoComics = success.data.count == 0
            let newComics = success.data.results
            comics.append(contentsOf: newComics)
        case .failure:
            comics = []
            print("Ошибка")
        }
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
                        CharacterDetailView(character: character, charactersService: .constant(charactersService))
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
