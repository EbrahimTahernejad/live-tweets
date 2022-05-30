//
//  APIStreamService.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation
import RxCocoa


enum APIStreamServiceURLs: EndPoint {
    case stream = "GET~tweets/search/stream?tweet.fields={tweet_fields}&expansions={expansions}&user.fields={user_fields}"
}

enum APIStreamServiceOutput {
    case disconnected, connecting, data(_ data: Data)
}

class APIStreamService: Service, APIStreamServiceProtocol {
    
    private let dispatchQueue = DispatchQueue(label: "com.Snapp.background")
    
    private lazy var urlSession: URLSession = {
        let operationQueue = OperationQueue()
        operationQueue.underlyingQueue = dispatchQueue
        let configuration = URLSessionConfiguration.default
        return URLSession(
            configuration: configuration,
            delegate: self,
            delegateQueue: operationQueue
        )
    }()
    
    private var dataTask: URLSessionDataTask?
    
    let output: PublishRelay<APIStreamServiceOutput> = .init()
    
    @discardableResult
    func connect() -> Bool {
        output.accept(.connecting)
        let urlRequest = APIStreamServiceURLs.stream.request.getRequest()
        dataTask = urlSession.dataTask(with: urlRequest)
        dataTask?.resume()
        return true
    }
    
    func disconnect() {
        dataTask?.cancel()
    }
    
}

protocol APIStreamServiceProtocol: ServiceProtocol {
    var output: PublishRelay<APIStreamServiceOutput> { get }
    func connect() -> Bool
    func disconnect()
}

extension APIStreamService: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(dataTask.state == .canceling ? .cancel : .allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard dataTask.state != .canceling else { return }
        output.accept(.data(data))
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        dataTask = nil
        output.accept(.disconnected)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
            let host = task.originalRequest?.url?.host
            if let serverTrust = challenge.protectionSpace.serverTrust, challenge.protectionSpace.authenticationMethod == NSURLAuthenticationMethodServerTrust && challenge.protectionSpace.host == host {
                completionHandler(.useCredential, URLCredential(trust: serverTrust))
            }
        }
}
