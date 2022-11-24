//
//  ApiManager.swift
//  Demo Pet App
//
//  Created by Danut Pralea on 21.11.2022.
//

import Foundation
import RxSwift
import RxCocoa

class ApiManager : NSObject {}

extension Reactive where Base: ApiManager {

    static func getToken() -> Observable<Void> {
        guard let key = Config.API_KEY, let secret = Config.API_SECRET else {
            return .empty()
        }
        
        let url = URL(string: Endpoint.token.rawValue)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.httpMethod = "POST"
        let parameters: [String: Any] = [
            "grant_type": "client_credentials",
            "client_id": key,
            "client_secret": secret
        ]
        request.httpBody = parameters.percentEncoded()
        
        return URLSession.shared
            .rx
            .data(request: request)
            .map {  try JSONDecoder().decode(Token.self, from: $0) }
            .do(onNext: { response in
                let data = try JSONEncoder().encode(response)
                KeychainHelper.standard.save(data, service: "access-token", account: "petfinder")
            })
            .map { _ in () }
    }

    static func getPets(type: String = "dog", page: Int = 0) -> Observable<[Pet]> {
        let decoder = JSONDecoder()
        guard let data = KeychainHelper.standard.read(service: "access-token", account: "petfinder"),
              let token = try? decoder.decode(Token.self, from: data) else {
            return .empty()
        }
        
        let url = URL(string: Endpoint.pets.rawValue)!
        var request = URLRequest(url: url)
        request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer \(token.access_token)", forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        return URLSession.shared
            .rx
            .data(request: request)
            .map { try JSONDecoder().decode(Animals.self, from: $0) }
            .map { $0.animals }
    }
    
}
