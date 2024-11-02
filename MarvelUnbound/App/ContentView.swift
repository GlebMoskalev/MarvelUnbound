//
//  ContentView.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import SwiftUI

struct ContentView: View {
    var comicService = ComicsService()
    var characterService = CharactersService()
    var eventsService = EventsService()

    
    var body: some View {
        Button {
            Task(priority: .background){
//                let result = await service.getCharacterId(id: 1011334)
                let result = await comicService.getComics()
                switch result{
                case .success(let character):
                    print(character.data.results.first)
                case .failure(let error):
                    print(error)
                }
            }
        } label: {
            Text("Touch Comics")
        }
        
        Button {
            Task(priority: .background){
//                let result = await service.getCharacterId(id: 1011334)
                let result = await characterService.getCharacters()
                switch result{
                case .success(let character):
                    print(character.data.results.first)
                case .failure(let error):
                    print(error)
                }
            }
        } label: {
            Text("Touch characterd")
        }
        
        Button {
            Task(priority: .background){
//                let result = await service.getCharacterId(id: 1011334)
                let result = await eventsService.getEvents()
                switch result{
                case .success(let character):
                    print(character.data.results.first)
                case .failure(let error):
                    print(error)
                }
            }
        } label: {
            Text("Touch events")
        }
    }
}

#Preview {
    ContentView()
}
