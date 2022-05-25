//
//  LanguageService.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import Combine


class LanguageService: Service {
    
    static var shared = LanguageService()
    
    enum Language: String {
        case en
    }
    
    @Published(key: "InspireMe.Language") var language: Language = .en
}
