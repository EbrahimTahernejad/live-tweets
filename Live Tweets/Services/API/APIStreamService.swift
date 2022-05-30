//
//  APIStreamService.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation
import RxCocoa


enum APIStreamServiceURLs: EndPoint {
    case stream = "GET~tweets/search/stream?tweet.fields={tweet_fields}&expansions={expansions}&user.fields={user_fields}&media.fields={media_fields}&poll.fields={poll_fields}"
}

enum APIStreamServiceOutput {
    case disconnected, connecting, data(_ data: Tweet)
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
    
    @discardableResult func connect() -> Bool {
        guard dataTask == nil else { return false }
        output.accept(.connecting)
        let urlRequest =
            APIStreamServiceURLs
                .stream
                .request
                .getRequest(params: [
                    "tweet_fields": "attachments,author_id,context_annotations,created_at,entities,geo,id,in_reply_to_user_id,lang,possibly_sensitive,public_metrics,referenced_tweets,source,text,withheld",
                    "expansions": "author_id,referenced_tweets.id,attachments.media_keys,attachments.poll_ids",
                    "user_fields": "created_at,profile_image_url,verified,url",
                    "media_fields": "duration_ms,height,media_key,preview_image_url,public_metrics,type,url,width,alt_text,variants",
                    "poll_fields": "end_datetime,voting_status,duration_minutes"
                ])
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
    @discardableResult
    func connect() -> Bool
    func disconnect()
}

extension APIStreamService: URLSessionDataDelegate {
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        completionHandler(dataTask.state == .canceling ? .cancel : .allow)
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        guard
            dataTask.state != .canceling,
            String(data: data, encoding: .utf8)?
                .trimmingCharacters(in: .whitespacesAndNewlines)
                .count ?? 0 > 0,
            let out = try? JSONDecoder().decode(Tweet.self, from: data)
        else {
            return
        }
        output.accept(.data(out))
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
