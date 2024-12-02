//
//  MainCharactersModel.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.12.2024.
//

import SwiftUI

@Observable
class MainCharactersModel {
    var characters: [Character] = []
    var charactersService = CharactersService()
    var isLoadingMore = false
    var isEverythingLoaded = false
    private var currentTask: Task<Void, Never>?
    
    func loadCharacters(refresh: Bool = false) async{
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
    
    func cancelCurrentTask(){
        currentTask?.cancel()
    }
    
    func startLoadingCharacters(refresh: Bool = false){
        cancelCurrentTask()
        isLoadingMore = true
        currentTask = Task(priority: .high) {
            await loadCharacters(refresh: refresh)
            isLoadingMore = false
        }
    }
}
