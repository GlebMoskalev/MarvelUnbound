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
    var sortSelection: SortSelection { get set }
    func endpointForId(_ id: Int) -> Endpoint
    func getEntityById(id: Int) async -> Swift.Result<BaseResponse<Entity>, RequestError>
    func getAllEntities() async -> Swift.Result<BaseResponse<Entity>, RequestError>
    func getEntitiesByIds(ids: [Int]) async -> [Entity]
    func getPopularIds() -> [Int]?
}


extension EntityServiceable where Self: HTTPClient{
    func getAllEntities() async -> Swift.Result<BaseResponse<Entity>, RequestError>{
        if sortSelection == .popular, let popularIds = getPopularIds(){
            let popularEntities = await getEntitiesByIds(ids: popularIds)
            let response = BaseResponse<Entity>(
                code: 200,
                status: "Ok",
                copyright: "© 2024 MARVEL",
                attributionText: "Data provided by Marvel. © 2024 MAR",
                attributionHTML: "<a href=\"http://marvel.com\">Data provided by Marvel. © 2024 MARVEL</a>",
                etag: "popular_response_\(Date().timeIntervalSince1970)",
                data: DataContainer(
                    offset: 0,
                    limit: popularEntities.count,
                    total: popularEntities.count,
                    count: popularEntities.count,
                    results: popularEntities)
            )
            return .success(response)
        }
        
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
