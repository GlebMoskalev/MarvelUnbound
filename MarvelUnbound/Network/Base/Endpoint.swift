//
//  Endpoint.swift
//  MarvelUnbound
//
//  Created by Глеб Москалев on 02.11.2024.
//

import Foundation
import CryptoKit

protocol Endpoint{
    var scheme: String { get }
    var host: String { get }
    var path: String { get }
    var method: RequestMethod { get }
    var header: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var sortSelection: SortSelection? { get }
}

extension Endpoint{
    var scheme: String {
        return "https"
    }
    
    var method: RequestMethod {
        return .get
    }
    
    var header: [String: String]? {
        return ["Accept": "*/*"]
    }
    
    var host: String {
        return "gateway.marvel.com"
    }
    
    var queryItems: [URLQueryItem]? {
        guard let privateKey = Bundle.main.object(forInfoDictionaryKey: "PRIVATE_KEY") as? String,
              let publicKey = Bundle.main.object(forInfoDictionaryKey: "PUBLIC_KEY") as? String
        else {
            return nil
        }
        let ts = String(Int(Date().timeIntervalSince1970))
        let hashInput = ts + privateKey + publicKey
        let hash = Insecure.MD5.hash(data: hashInput.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
        var items = [
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "hash", value: hash),
        ]
        
        if let sortSelection = self.sortSelection,
           sortSelection != .popular {
            items.append(URLQueryItem(name: "orderBy", value: sortSelection.orderByValue))
        }
        
        return items
    }
}
