//
//  CardCharacter.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 06.11.2024.
//

import SwiftUI

struct CardCharacter: View {
    let character: Character
    
    var body: some View {
        HStack(spacing: 0){
            AsyncImage(url: URL(string: character.thumbnail.path + "/standard_xlarge." + character.thumbnail.thumbnailExtension))
            
            VStack(spacing: 0){
                VStack(spacing: 0){
                    let nameSplit = character.name.split(separator: "(")
                    let firstPart = nameSplit[0].trimmingCharacters(in: .whitespaces)
                    Text(firstPart)
                        .font(Font.customFont(.inter, style: .bold, size: 20))
                        .lineLimit(1)
                        .minimumScaleFactor(0.5)
                        .padding(.top, 8)
                    
                    if nameSplit.count == 2{
                        let secondPart = String(nameSplit[1].dropLast())
                        Text(secondPart)
                            .font(Font.customFont(.inter, style: .bold, size: 12))
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                    }
                }
                
                Group{
                    if character.description.isEmpty{
                        Text("There is no description")
                            .font(Font.customFont(.inter, style: .light, size: 10))
                    } else{
                        Text(character.description)
                            .font(Font.customFont(.inter, style: .light, size: 8))
                            .frame(maxHeight: 40)
                    }
                }
                .padding(.top, 20)
                
                if character.comics.items.count != 0{
                    HStack(spacing: 0){
                        Text("Comics")
                            .font(Font.customFont(.inter, style: .medium, size: 10))
                            .padding(.top, 10)
                        Spacer()
                    }
                    
                    let countComics = character.description.isEmpty ? 3 : 2
                    ForEach(character.comics.items.prefix(countComics), id: \.name){ comic in
                        HStack(spacing: 0){
                            Text("•\(comic.name)")
                                .font(Font.customFont(.inter, style: .light, size: 8))
                            Spacer()
                        }
                    }
                }
                
                Spacer()
                
                HStack(spacing: 0){
                    Spacer()
                    
                    Button{
                        print("view")
                    } label: {
                        HStack(spacing: 0){
                            Text("More info")
                                .font(Font.customFont(.inter, style: .medium, size: 8))
                            
                            Image(systemName: "chevron.right")
                        }
                        .foregroundStyle(.black)
                    }
                }
                .padding(.bottom, 5)
                
                
            }
            .padding(.horizontal, 15)
            .frame(width: 150)
        }
        .frame(width: 350, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct CardCharacter_Preview: View {
    let charactersService = CharactersService()
    @State var character: Character?
    
    var body: some View {
        VStack{
            if let character = character {
                CardCharacter(character: character)
            } else {
                Text("Loading")
            }
        }
        .task {
            await getCharacter()
        }
    }
    
    func getCharacter() async {
        let response = await charactersService.getEntityById(id: 1010744)
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
    CardCharacter_Preview()
}
