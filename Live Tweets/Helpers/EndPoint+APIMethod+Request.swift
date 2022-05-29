//
//  EndPoint+APIMethod.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/8/1401 AP.
//

import Foundation
import Combine

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
    // Main method
    private func send<Res: Decodable>(
        params: [String:String] = [:],
        headers: [String:String] = [:],
        body: Data?
    ) -> AnyPublisher<Res, Error> {
        // Add parameters and create url
        var urlStr = url
        for k in params.keys {
            let encoded = params[k]?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
            urlStr = urlStr.replacingOccurrences(of: "{\(k)}", with: encoded)
        }
        var req = URLRequest(url: URL(string: urlStr)!)
        
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
            req.setValue("application/json", forHTTPHeaderField: "Content-Type")
            req.httpBody = body
        }
        
        // Finish up
        return URLSession.shared.dataTaskPublisher(for: req).mapError({ $0 as Error }).tryMap({ response in
            try JSONDecoder().decode(Res.self, from: response.data)
        }).eraseToAnyPublisher()
    }
    
    // Send without body
    func send<Res: Decodable>(
        params: [String:String] = [:],
        headers: [String:String] = [:]
    ) -> AnyPublisher<Res, Error> {
        return self.send(params: params, headers: headers, body: nil)
    }
    
    // Send with body
    func send<Res: Decodable, Req: Encodable>(
        body: Req,
        params: [String:String] = [:],
        headers: [String:String] = [:]
    ) -> AnyPublisher<Res, Error> {
        do {
            let body = try JSONEncoder().encode(body)
            return self.send(params: params, headers: headers, body: body)
        } catch {
            return Fail<Res, Error>(error: error as Error).eraseToAnyPublisher()
        }
    }
}
