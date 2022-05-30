//
//  APIRulesService.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/8/1401 AP.
//

import Combine
import Foundation

enum APIRulesServiceURLs: EndPoint {
    case edit = "POST~tweets/search/stream/rules"
    case get = "GET~tweets/search/stream/rules"
}

class APIRulesService: Service, APIRulesServiceProtocol {
    
    func create(rules: [Rule]) -> AnyPublisher<RulesData, Error> {
        return APIRulesServiceURLs.edit.request.send(body: RulesAdd(add: rules))
    }
    
    func reset(rules: [Rule]) -> AnyPublisher<RulesData, Error> {
        return deleteAll().map{_ in return rules}
            .flatMap(create).eraseToAnyPublisher()
    }
    
    func getAll() -> AnyPublisher<RulesData, Error> {
        return APIRulesServiceURLs.get.request.send()
    }
    
    func delete(rules: [Rule]) -> AnyPublisher<EmptyResponse, Error> {
        return APIRulesServiceURLs.edit.request.send(
            body: RulesDelete(delete: .init(ids: rules.compactMap({ $0.id })))
        )
    }
    
    func deleteAll() -> AnyPublisher<EmptyResponse, Error> {
        return getAll().map{$0.data}
            .flatMap(delete).eraseToAnyPublisher()
    }
    
}

protocol APIRulesServiceProtocol: AnyObject {
    func create(rules: [Rule]) -> AnyPublisher<RulesData, Error>
    func reset(rules: [Rule]) -> AnyPublisher<RulesData, Error>
    func getAll() -> AnyPublisher<RulesData, Error>
    func delete(rules: [Rule]) -> AnyPublisher<EmptyResponse, Error>
    func deleteAll() -> AnyPublisher<EmptyResponse, Error>
}
