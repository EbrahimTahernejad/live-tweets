//
//  APIRulesService.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/8/1401 AP.
//

import RxSwift
import Foundation

enum APIRulesServiceURLs: EndPoint {
    case edit = "POST~tweets/search/stream/rules"
    case get = "GET~tweets/search/stream/rules"
}

class APIRulesService: Service, APIRulesServiceProtocol {
    
    func create(rules: [Rule]) -> Observable<RulesData> {
        return APIRulesServiceURLs.edit.request.send(body: RulesAdd(add: rules))
    }
    
    func reset(rules: [Rule]) -> Observable<RulesData> {
        return deleteAll().map{_ in return rules}.flatMap(create)
    }
    
    func getAll() -> Observable<RulesData> {
        return APIRulesServiceURLs.get.request.send()
    }
    
    func delete(rules: [Rule]) -> Observable<EmptyResponse> {
        return APIRulesServiceURLs.edit.request.send(
            body: RulesDelete(delete: .init(ids: rules.compactMap({ $0.id })))
        )
    }
    
    func deleteAll() -> Observable<EmptyResponse> {
        return getAll().map{$0.data}.flatMap(delete)
    }
    
}

protocol APIRulesServiceProtocol: ServiceProtocol {
    func create(rules: [Rule]) -> Observable<RulesData>
    func reset(rules: [Rule]) -> Observable<RulesData>
    func getAll() -> Observable<RulesData>
    func delete(rules: [Rule]) -> Observable<EmptyResponse>
    func deleteAll() -> Observable<EmptyResponse>
}
