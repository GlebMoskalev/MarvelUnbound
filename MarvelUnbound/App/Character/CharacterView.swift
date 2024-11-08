//
//  CharacterView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 06.11.2024.
//

import SwiftUI

struct CharacterView: View {
    @State var selectedSortSelection: SortSelection = .popular
    @State var characters: [Character] = []
    
    var body: some View {
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
                        LoadingView()
                        Spacer()
                    }.padding(.top, UIScreen.main.bounds.height / 3)
                }
                
                ForEach(characters, id: \.id) { character in
                    CardCharacter(character: character)
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            Spacer()
        }
        .task {
            await getAllCharacters()
        }
    }
    
    func getAllCharacters() async {
        let response = await CharactersService(sortSelection: selectedSortSelection).getAllEntities()
        switch response {
        case .success(let success):
            characters = success.data.results
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
    CharacterView()
}
