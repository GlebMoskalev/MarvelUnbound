//
//  CardCharcterView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 01.12.2024.
//


import SwiftUI

struct CardCharacterView: View {
    @State var viewModel: CardCharacterViewModel
    
    var body: some View {
        HStack(spacing: 0){
            CharacterImageView(imageURL: viewModel.imageURL)
            VStack(spacing: 5){
                CharacterNameView(nameParts: viewModel.nameParts)
                CharacterDescriptionView(description: viewModel.description)
                CharacterComicsView(comics: viewModel.comics)
                CharacterModifiedDateView(modifiedDate: viewModel.modifiedDate)
                
                Spacer()
                
                MoreButton(moreLink: CharacterDetailView(viewModel: CharacterDetailViewModel(character: viewModel.character, charactersService: viewModel.characterService)))
                    .padding(.bottom, 5)
                

            }
            .padding(5)
            .frame(width: 150)
            
        }
        .frame(width: 350, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct CharacterImageView: View {
    let imageURL: URL?
    var body: some View {
        AsyncImage(url: imageURL) { image in
            image
        } placeholder: {
            ZStack(alignment: .center){
                UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 15)
                    .frame(width: 200, height: 200)
                
                LoadingView(sizeText: 25)
            }
        }
    }
}

private struct CharacterModifiedDateView: View {
    let modifiedDate: String
    
    var body: some View {
        VStack(spacing: 0){
            Text("Modified:")
                .font(Font.customFont(.inter, style: .semiBold, size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(modifiedDate)
                .font(Font.customFont(.inter, style: .light, size: 11))
                .frame(maxWidth: .infinity, alignment: .leading)
            
        }
    }
}

private struct MoreButton: View {
    let moreLink: CharacterDetailView
    
    var body: some View {
        HStack(spacing: 0){
            Spacer()
            NavigationLink{
                moreLink
            } label: {
                HStack(spacing: 5){
                    Text("More info")
                        .font(Font.customFont(.inter, style: .medium, size: 10))
                    
                    Image(systemName: "chevron.right")
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 8)
                }
                .foregroundStyle(.black)
            }
        }
    }
}

private struct CharacterComicsView: View {
    let comics: [String]
    
    var body: some View {
        if !comics.isEmpty{
            VStack(spacing: 0){
                Text("Comics:")
                    .font(Font.customFont(.inter, style: .semiBold, size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(comics, id: \.self){ comic in
                    Text("•\(comic)")
                        .font(Font.customFont(.inter, style: .light, size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

private struct CharacterDescriptionView: View {
    let description: String
    
    var body: some View {
        Text(description)
            .font(Font.customFont(.inter, style: .light, size: 12))
            .frame(maxWidth: .infinity, alignment: .leading)
            .lineLimit(3)
    }
}

private struct CharacterNameView: View {
    let nameParts: (String, String?)
    
    var body: some View {
        VStack(spacing: 0){
            Text(nameParts.0)
                .font(Font.customFont(.inter, style: .bold, size: 16))
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            if let secondPart = nameParts.1{
                Text(secondPart)
                    .font(Font.customFont(.inter, style: .medium, size: 14))
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
    }
}

private struct CardCharacter_Preview: View {
    let charactersService = CharactersService()
    @State var character: Character?
    
    var body: some View {
        VStack{
            if let character = character {
                CardCharacterView(viewModel: CardCharacterViewModel(character: character, characterService: CharactersService()))
            } else {
                Text("Loading")
            }
        }
        .task {
            await getCharacter()
        }
    }
    
    func getCharacter() async {
        // 1011299
        let response = await charactersService.getEntityById(id: 1009504)
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

