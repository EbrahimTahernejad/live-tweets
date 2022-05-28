//
//  LanguageService.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/7/1401 AP.
//

import Combine

enum Language: String {
    case en
}

protocol LanguageServiceProtocol: AnyObject {
    var language: Language { set get }
}

class LanguageService: Service, LanguageServiceProtocol {
    @Published(key: "LiveTweets.Language") var language: Language = .en
}
