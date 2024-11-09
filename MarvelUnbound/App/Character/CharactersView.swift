//
//  CharacterView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 06.11.2024.
//

import SwiftUI


// TODO: когда выбираешь к примеру A-Z происходит загрузка, если не дождаться загрузки и выбрать Z-A то сначала загрузится A-Z, а только потом начнет грузиться Z-A
struct CharactersView: View {
    @State var selectedSortSelection: SortSelection = .popular
    @State var characters: [Character] = []
    @State var charactersService = CharactersService()
    @State var isLoadingMore = false
    @State var isEverythingLoaded = false
    
    var body: some View {
        NavigationStack {
            BackToTopScrollView{ _ in
                VStack(alignment: .leading, spacing: 20){
                    HeaderView()
                    SortView(selected: $selectedSortSelection, actionButton: {
                        Task(priority: .medium){
                            self.characters = []
                            await getAllCharacters()
                        }
                    })
                    
                    if characters.isEmpty{
                        HStack{
                            Spacer()
                            LoadingView(sizeText: 30)
                            Spacer()
                        }.padding(.top, UIScreen.main.bounds.height / 3)
                    }
                    
                    ForEach(characters, id: \.id) { character in
                        CardCharacter(character: character)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                    
                    if selectedSortSelection != .popular && !characters.isEmpty && !isLoadingMore{
                        Button{
                            Task(priority: .medium){
                                isLoadingMore = true
                                await loadMoreCharacters()
                                isLoadingMore = false
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
                    } else if isLoadingMore{
                        LoadingView(sizeText: 20)
                            .frame(maxWidth: .infinity, alignment: .center)
                    }
                }
            }
            .task {
                await getAllCharacters()
            }
        }
    }
    
    private func getAllCharacters() async {
        charactersService.sortSelection = selectedSortSelection
        let response = await charactersService.getAllEntities()
        switch response {
        case .success(let success):
            characters = success.data.results
        case .failure:
            characters = []
            print("Ошибка")
        }
    }
    
    private func loadMoreCharacters() async {
        charactersService.increaseOffset()
        let response = await charactersService.getAllEntities()
        switch response {
        case .success(let success):
            if success.data.results.isEmpty{
                isEverythingLoaded = true
            }
            characters += success.data.results
        case .failure:
            characters = []
            print("Ошибка")
        }
    }
}



struct HeaderView: View {
    var body: some View {
        HStack(spacing: 0){
            Text("Marvel unbound")
                .font(Font.customFont(.bangers, style: .regular, size: 20))
                .padding(.leading, 15)
            
            Spacer()
            
            Button{
                print("Открытие")
            } label: {
                Image(systemName: "magnifyingglass")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 20)
                    .foregroundStyle(.black)
            }
        }
    }
}

#Preview {
    CharactersView()
}
