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
    var comics: [Comic] = []
    
    
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
                
                Text(character.description)
                    .font(Font.customFont(.inter, style: .regular, size: 15))
                    .padding(20)
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
                        CharacterDetailView(character: character)
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
