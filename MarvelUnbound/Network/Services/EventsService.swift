//
//  EventsServiceable.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

protocol EventsServiceable{
    func getEventId(id: Int) async -> Swift.Result<EventsResponse, RequestError>
    func getEvents() async -> Swift.Result<EventsResponse, RequestError>
}

struct EventsService: HTTPClient, EventsServiceable{
    func getEventId(id: Int) async -> Swift.Result<EventsResponse, RequestError> {
        return await sendRequest(endpoint: EventsEndpoint.eventId(id: id), responseModel: EventsResponse.self)
    }
    
    func getEvents() async -> Swift.Result<EventsResponse, RequestError> {
        return await sendRequest(endpoint: EventsEndpoint.events, responseModel: EventsResponse.self)
    }
}
