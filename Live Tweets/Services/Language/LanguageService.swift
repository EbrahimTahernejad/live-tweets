//
//  LanguageService.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/7/1401 AP.
//

import RxCocoa
import RxSwift
import Foundation

enum Language: String {
    case en
}

protocol LanguageServiceProtocol: AnyObject {
    var language: UserDefaultsRelay<String> { get }
}

@dynamicMemberLookup
class LanguageService: Service, LanguageServiceProtocol {
    
    let language: UserDefaultsRelay<String> =
        .init(
            key: "LiveTweets.Defaults.Language",
            default: Language.en.rawValue
        )
    
    subscript(dynamicMember member: String) -> String {
        return NSLocalizedString(member, tableName: language.value, bundle: .main, value: member, comment: member)
    }
    
    subscript(dynamicMember member: String) -> Observable<String> {
        return language.map({
            return NSLocalizedString(member, tableName: $0, bundle: .main, value: member, comment: member)
        })
    }
    
}
