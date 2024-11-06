//
//  EntityServiceable.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

protocol EntityServiceable {
    associatedtype Entity: Codable
    
    var endpointForAll: Endpoint { get }
    func endpointForId(_ id: Int) -> Endpoint
    
    func getEntityById(id: Int) async -> Swift.Result<BaseResponse<Entity>, RequestError>
    func getAllEntities() async -> Swift.Result<BaseResponse<Entity>, RequestError>
    func getEntitiesByIds(ids: [Int]) async -> [Entity]
}


extension EntityServiceable where Self: HTTPClient{
    func getAllEntities() async -> Swift.Result<BaseResponse<Entity>, RequestError>{
        return await sendRequest(endpoint: endpointForAll, responseModel: BaseResponse<Entity>.self)
    }
    
    func getEntityById(id: Int) async -> Swift.Result<BaseResponse<Entity>, RequestError>{
        return await sendRequest(endpoint: endpointForId(id), responseModel: BaseResponse<Entity>.self)
    }
    
    func getEntitiesByIds(ids: [Int]) async -> [Entity]{
        var entities: [Entity] = []
        
        await withTaskGroup(of: Entity?.self){ group in
            for id in ids {
                group.addTask{
                    let result = await self.getEntityById(id: id)
                    switch result{
                    case .success(let entity):
                        return entity.data.results.first
                    case .failure:
                        return nil
                    }
                }
            }
            
            for await entity in group{
                if let entity = entity{
                    entities.append(entity)
                }
            }
        }
        return entities
    }
}
