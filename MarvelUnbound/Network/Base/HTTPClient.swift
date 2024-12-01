//
//  HTTPClient.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation

protocol HTTPClient{
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Swift.Result<T, RequestError>
}

extension HTTPClient{
    func sendRequest<T: Decodable>(endpoint: Endpoint, responseModel: T.Type) async -> Swift.Result<T, RequestError>{
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.path
        
        if let queryItems = endpoint.queryItems{
            urlComponents.queryItems = queryItems
        }
        
        guard let url = urlComponents.url else {
            return .failure(.invalidURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.header
        
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request, delegate: nil)

            guard let response = response as? HTTPURLResponse else{
                return .failure(.noResponse)
            }
            switch response.statusCode{
            case 200...299:
                do {
                    let decodeResponse = try JSONDecoder().decode(responseModel, from: data)
                    return .success(decodeResponse)
                } catch let decodingError {
                    print("Decoding error: \(decodingError)")
                    return .failure(.decode)
                }

//                guard let decodeResponse = try? JSONDecoder().decode(responseModel, from: data) else {
//                    return .failure(.decode)
//                }
//                return .success(decodeResponse)
            case 401:
                return .failure(.unauthorized)
            default:
                return .failure(.unexpectedStatusCode)
            }
            
        } catch{
            return .failure(.unknown)
        }
    }
}
