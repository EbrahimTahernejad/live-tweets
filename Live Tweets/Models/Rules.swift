//
//  Rule.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/8/1401 AP.
//

import Foundation


struct Rule: Codable {
    let value: String
    let tag: String?
    let id: String?
}

struct RulesAdd: Codable {
    let add: [Rule]
}

struct RulesMetaSummary: Codable {
    let created: Int
    let not_created: Int
    let valid: Int
    let invalid: Int
}

struct RulesMeta: Codable {
    let sent: String
    let summary: RulesMetaSummary?
}

struct RulesData: Codable {
    let data: [Rule]
    let meta: RulesMeta
}

struct RulesIDs: Codable {
    let ids: [String]
}

struct RulesDelete: Codable {
    let delete: RulesIDs
}
