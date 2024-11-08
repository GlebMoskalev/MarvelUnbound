//
//  CharacterView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 06.11.2024.
//

import SwiftUI

struct CharacterView: View {
    @State var selectedSortSelection: SortSelection = .popular
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20){
            HeaderView()
            SortView(selected: $selectedSortSelection)
                .task {
                    await getAllCharacters()
                }
            Spacer()
        }
    }
    
    func getAllCharacters() async {
        let characters = await CharactersService(sortSelection: .popular).getAllEntities()
        print(characters)
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
