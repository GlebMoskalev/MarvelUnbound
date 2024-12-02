//
//  MainCharactersView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.12.2024.
//

import SwiftUI

struct MainCharactersView: View {
    @State private var model = MainCharactersModel()
    
    var body: some View {
        NavigationStack {
            BackToTopScrollView{ _ in
                VStack(alignment: .leading, spacing: 20){
                    HeaderView()
                    SortView(service: $model.charactersService, actionButton: {
                        model.startLoadingCharacters(refresh: true)
                    })
                    
                    if model.characters.isEmpty{
                        HStack{
                            Spacer()
                            LoadingView(sizeText: 30)
                            Spacer()
                        }.padding(.top, UIScreen.main.bounds.height / 3)
                    } else{
                        ForEach(model.characters, id: \.id) { character in
                            CardCharacterView(model: CardCharacterModel(character: character, characterService: model.charactersService))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        if model.charactersService.sortSelection != .popular && !model.characters.isEmpty && !model.isLoadingMore{
                            LoadMoreButton(action: {
                                model.startLoadingCharacters()
                            })
                        } else if model.isLoadingMore{
                            LoadingView(sizeText: 20)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
        }
        .onAppear{
            model.startLoadingCharacters(refresh: true)
        }
        .onDisappear{
            model.cancelCurrentTask()
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
    MainCharactersView()
}
