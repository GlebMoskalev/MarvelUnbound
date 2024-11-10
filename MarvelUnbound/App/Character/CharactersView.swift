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
    @State private var currentTask: Task<Void, Never>?
    
    var body: some View {
        NavigationStack {
            BackToTopScrollView{ _ in
                VStack(alignment: .leading, spacing: 20){
                    HeaderView()
                    SortView(service: $charactersService, actionButton: {
                        currentTask?.cancel()
                        self.characters = []
                        currentTask = Task(priority: .medium){
                            await loadCharacters(refresh: true)
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
                    
                    if charactersService.sortSelection != .popular && !characters.isEmpty && !isLoadingMore{
                        Button{
                            currentTask?.cancel()
                            isLoadingMore = true
                            currentTask = Task(priority: .medium){
                                await loadCharacters()
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
        }
        .onAppear{
            currentTask?.cancel()
            currentTask = Task(priority: .high){
                await loadCharacters(refresh: true)
            }
        }
        .onDisappear{
            currentTask?.cancel()
        }
    }
    private func loadCharacters(refresh: Bool = false) async{
        guard !Task.isCancelled else { return }
        
        if refresh{
            charactersService.offset = 0
            characters = []
        } else{
            charactersService.increaseOffset()
        }
        let response = await charactersService.getAllEntities()
        guard !Task.isCancelled else { return }
        
        switch response {
        case .success(let success):
            let newCharacters = success.data.results
            if newCharacters.isEmpty{
                isEverythingLoaded = true
            } else{
                characters.append(contentsOf: newCharacters)
            }
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
