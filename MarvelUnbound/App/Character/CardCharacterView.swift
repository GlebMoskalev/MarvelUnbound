//
//  CardCharacter.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 06.11.2024.
//

import SwiftUI

struct CardCharacter: View {
    let character: Character
    @Binding var characterService: CharactersService
    
    var body: some View {
        HStack(spacing: 0){
            AsyncImage(url: URL(string: character.thumbnail.path + "/standard_xlarge." + character.thumbnail.thumbnailExtension)) { image in
                image
            } placeholder: {
                ZStack(alignment: .center){
                    UnevenRoundedRectangle(topLeadingRadius: 15, bottomLeadingRadius: 15)
                        .frame(width: 200, height: 200)
                    
                    LoadingView(sizeText: 25)
                }
            }
            
            VStack(spacing: 5){
                NameView(name: character.name)
                
                DescriptionView(description: character.description)
                
                ComicsView(comicsResourceItem: character.comics.items)
                
                ModifiedView(modified: character.modified)
                
                Spacer()
                
                MoreButton(moreLink: CharacterDetailView(character: character, charactersService: $characterService))
                    .padding(.bottom, 5)
                

            }
            .padding(5)
            .frame(width: 150)
            
        }
        .frame(width: 350, height: 200)
        .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

private struct ModifiedView: View {
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    
    private let displayDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE, MMM d, yyyy"
        return formatter
    }()
    
    let modified: String
    
    var body: some View {
        VStack(spacing: 0){
            Text("Modified:")
                .font(Font.customFont(.inter, style: .semiBold, size: 12))
                .frame(maxWidth: .infinity, alignment: .leading)
            
            let date = dateFormatter.date(from: modified)
            Text(displayDateFormatter.string(from: date ?? Date()))
                .font(Font.customFont(.inter, style: .light, size: 12))
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

private struct ComicsView: View {
    let comicsResourceItem: [ResourceItem]
    
    var body: some View {
        if comicsResourceItem.count != 0{
            VStack(spacing: 0){
                Text("Comics:")
                    .font(Font.customFont(.inter, style: .semiBold, size: 12))
                    .frame(maxWidth: .infinity, alignment: .leading)
                
                ForEach(comicsResourceItem.prefix(2), id: \.name){ comic in
                    Text("•\(comic.name)")
                        .font(Font.customFont(.inter, style: .light, size: 12))
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

private struct DescriptionView: View {
    let description: String
    
    var body: some View {
        Group{
            if description.isEmpty{
                Text("There is no description")
                    .font(Font.customFont(.inter, style: .light, size: 12))
            } else{
                Text(description)
                    .font(Font.customFont(.inter, style: .light, size: 12))
                    .frame(maxHeight: 40)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
}

private struct NameView: View {
    let name: String
    
    var body: some View {
        VStack(spacing: 0){
            let nameSplit = name.split(separator: "(")
            let firstPart = nameSplit[0].trimmingCharacters(in: .whitespaces)
            Text(firstPart)
                .font(Font.customFont(.inter, style: .bold, size: 16))
                .padding(.top, 8)
                .frame(maxWidth: .infinity, alignment: .leading)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            if nameSplit.count == 2{
                let secondPart = String(nameSplit[1].dropLast())
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
                CardCharacter(character: character, characterService: .constant(charactersService))
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

