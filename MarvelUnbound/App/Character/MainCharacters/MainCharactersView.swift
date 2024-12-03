//
//  MainCharactersView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.12.2024.
//

import SwiftUI

struct MainCharactersView: View {
    @State private var viewModel = MainCharactersViewModel()
    
    var body: some View {
        NavigationStack {
            BackToTopScrollView{ _ in
                VStack(alignment: .leading, spacing: 20){
                    HeaderView()
                    SortView(service: $viewModel.charactersService, actionButton: {
                        viewModel.startLoadingCharacters(refresh: true)
                    })
                    
                    if viewModel.characters.isEmpty{
                        HStack{
                            Spacer()
                            LoadingView(sizeText: 30)
                            Spacer()
                        }.padding(.top, UIScreen.main.bounds.height / 3)
                    } else{
                        ForEach(viewModel.characters, id: \.id) { character in
                            CardCharacterView(viewModel: CardCharacterViewModel(character: character, characterService: viewModel.charactersService))
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                        
                        if viewModel.charactersService.sortSelection != .popular && !viewModel.characters.isEmpty && !viewModel.isLoadingMore{
                            LoadMoreButton(action: {
                                viewModel.startLoadingCharacters()
                            })
                        } else if viewModel.isLoadingMore{
                            LoadingView(sizeText: 20)
                                .frame(maxWidth: .infinity, alignment: .center)
                        }
                    }
                }
            }
        }
        .onAppear{
            viewModel.startLoadingCharacters(refresh: true)
        }
        .onDisappear{
            viewModel.cancelCurrentTask()
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
