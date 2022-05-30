//
//  EndPoint+APIMethod.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/8/1401 AP.
//

import Foundation
import RxSwift
import RxCocoa

// Can be added if it's necessary. No further edits required.
enum APIMethod: String {
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
}

// Empty Response
struct EmptyResponse: Codable {}

// Processes "METHOD~PATH" Enums
struct EndPoint: Equatable, ExpressibleByStringLiteral {
    private let string: String
    let method: APIMethod
    let url: String
    init(stringLiteral: String) {
        string = stringLiteral
        let rawMethod = String(string.split(separator: "~")[0])
        let rawUrl = String(string.split(separator: "~")[1])
        method = APIMethod(rawValue: rawMethod) ?? .get
        guard let baseUrl = Bundle.main.object(forInfoDictionaryKey: "TWITTER_BASE_URL") as? String
            else {
            fatalError("TWITTER_BASE_URL is not present in configuration!")
        }
        url = "\(baseUrl)\(rawUrl)"
    }
}

// Extension for enums, just for readability
extension RawRepresentable where RawValue == EndPoint {
    var request: EndPoint {
        return rawValue
    }
}

extension EndPoint {
    
    private func getRequest(
        params: [String:String],
        headers: [String:String],
        body: Data?
    ) -> URLRequest {
        // Add parameters and create url
        var urlStr = url
        for k in params.keys {
            let encoded = params[k]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlStr = urlStr.replacingOccurrences(of: "{\(k)}", with: encoded)
        }
        var req = URLRequest(url: URL(string: urlStr)!)
        
        // Set the method
        req.httpMethod = method.rawValue
        
        // Set headers
        guard let bearerToken = Bundle.main.object(forInfoDictionaryKey: "TWITTER_BEARER_TOKEN") as? String
            else {
            fatalError("TWITTER_BEARER_TOKEN is not present in configuration!")
        }
        for header in headers.keys {
            let value = headers[header] ?? ""
            req.setValue(value, forHTTPHeaderField: header)
        }
        req.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        
        // Set body if present
        if let body = body {
            req.httpBody = body
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        } else {
            req.httpBody = nil
        }
        
        return req
    }
    
    // Main method
    private func send<Res: Decodable>(
        params: [String:String],
        headers: [String:String],
        body: Data?
    ) -> Observable<Res> {
        // Create request object
        let req = getRequest(params: params, headers: headers, body: body)
        
        // Send request
        return URLSession.shared.rx.data(request: req).map { response in
            // Handle empty responses
            if let response = EmptyResponse() as? Res {
                return response
            }
            // Decode the JSON reponse
            return try JSONDecoder().decode(Res.self, from: response)
        }
    }
    
    // Send without body
    func send<Res: Decodable>(
        params: [String:String] = [:],
        headers: [String:String] = [:]
    ) -> Observable<Res> {
        return send(params: params, headers: headers, body: nil)
    }
    
    // Send with body
    func send<Res: Decodable, Req: Encodable>(
        body: Req,
        params: [String:String] = [:],
        headers: [String:String] = [:]
    ) -> Observable<Res> {
        do {
            let body = try JSONEncoder().encode(body)
            return send(params: params, headers: headers, body: body)
        } catch {
            return Observable.error(error)
        }
    }
    
    func getRequest(
        params: [String:String] = [:],
        headers: [String:String] = [:]
    ) -> URLRequest {
        return getRequest(params: params, headers: headers, body: nil)
    }
    
    func getRequest<Req: Encodable>(
        body: Req,
        params: [String:String] = [:],
        headers: [String:String] = [:]
    ) -> URLRequest? {
        guard
            let body = try? JSONEncoder().encode(body)
        else {
            return nil
        }
        return getRequest(params: params, headers: headers, body: body)
    }
}
