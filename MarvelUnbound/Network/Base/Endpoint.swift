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
        guard let privateKey = Bundle.main.object(forInfoDictionaryKey: "PRIVATE_KEY") as? String else {
            return nil
        }
        let publicKey = "3ee4acd1209f85fdd57e550fd2926148"
        let ts = String(Int(Date().timeIntervalSince1970))
        let hashInput = ts + privateKey + publicKey
        let hash = Insecure.MD5.hash(data: hashInput.data(using: .utf8)!).map { String(format: "%02hhx", $0) }.joined()
        return [
            URLQueryItem(name: "apikey", value: publicKey),
            URLQueryItem(name: "ts", value: ts),
            URLQueryItem(name: "hash", value: hash)
        ]
    }
}
