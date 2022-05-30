//
//  Dependencies.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation

struct Dependencies {
    weak var languageService: LanguageServiceProtocol?
    weak var router: RouterProtocol?
    weak var apiRulesService: APIRulesServiceProtocol?
    weak var apiStreamService: APIStreamServiceProtocol?
}

struct DependenciesStrong {
    var languageService: LanguageServiceProtocol?
    var router: RouterProtocol?
    var apiRulesService: APIRulesServiceProtocol?
    var apiStreamService: APIStreamServiceProtocol?
}


struct DependencyOptions: OptionSet {
    var rawValue: Int64
    
    static let languageService = DependencyOptions(rawValue: 1 << 0)
    static let router = DependencyOptions(rawValue: 1 << 1)
    static let apiRulesService = DependencyOptions(rawValue: 1 << 2)
    static let apiStreamService = DependencyOptions(rawValue: 1 << 4)
    // static let lastService = DependencyOptions(rawValue: 1 << 5)
}
