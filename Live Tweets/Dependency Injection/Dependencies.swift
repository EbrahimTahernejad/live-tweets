//
//  DependencyInjection.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/7/1401 AP.
//

import Combine


struct Dependencies {
    weak var languageService: LanguageServiceProtocol?
    weak var router: RouterProtocol?
    weak var apiRulesService: APIRulesServiceProtocol?
}

struct DependenciesStrong {
    var languageService: LanguageServiceProtocol?
    var router: RouterProtocol?
    var apiRulesService: APIRulesServiceProtocol?
}


struct DependencyOptions: OptionSet {
    var rawValue: Int64
    
    static let languageService = DependencyOptions(rawValue: 1 << 0)
    static let router = DependencyOptions(rawValue: 1 << 1)
    static let apiRulesService = DependencyOptions(rawValue: 1 << 2)
    // static let lastService = DependencyOptions(rawValue: 1 << 3)
}
