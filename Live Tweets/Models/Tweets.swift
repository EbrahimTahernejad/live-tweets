//
//  Tweets.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation
import RxCocoa
import RxSwift

protocol RangeItem {
    var start: Int { get }
    var end: Int { get }
}

struct Tweet: Codable {
    let data: TweetData
    let includes: TweetIncludes?
}

struct TweetData: Codable {
    let identifier = UUID().uuidString
    
    let entities: TweetEntities?
    let attachments: TweetAttachments?
    let public_metrics: TweetMetrics?
    let referenced_tweets: [TweetReference]?
    let text: String
    let source: String?
    let created_at: Date
    let author_id: String
    let id: String
}

struct TweetReference: Codable {
    enum ReferenceType: String, Codable {
        case retweeted, replied_to, quoted
    }
    
    let type: ReferenceType
    let id: String
}

struct TweetMetrics: Codable {
    let retweet_count: Int?
    let reply_count: Int?
    let like_count: Int?
    let quote_count: Int?
}

struct TweetAttachments: Codable {
    let media_keys: [String]?
    let poll_ids: [String]?
}

struct TweetEntities: Codable {
    let urls: [TweetURL]?
    let hashtags: [TweetTag]?
    let cashtags: [TweetTag]?
    let mentions: [TweetMention]?
}

struct TweetTag: Codable, RangeItem {
    let start: Int
    let end: Int
    let tag: String
}

struct TweetMention: Codable, RangeItem {
    let start: Int
    let end: Int
    let username: String
}

struct TweetURL: Codable, RangeItem {
    let identifier = UUID().uuidString
    
    let start: Int
    let end: Int
    let url: String
    let display_url: String?
    let title: String?
    let description: String?
    let images: [TweetURLImage]?
}

struct TweetURLImage: Codable {
    let url: String
    let height: Int
    let width: Int
}

struct TweetPoll: Codable {
    let identifier = UUID().uuidString
    
    struct PollOption: Codable {
        let position: Int
        let label: String
        let votes: Int
    }
    
    enum PollStatus: String, Codable {
        case open, closed
    }
    
    let options: [PollOption]
    let id: String
    let status: PollStatus
    let end_datetime: Date
    let duration_minutes: Int
}

struct TweetUser: Codable {
    let id: String
    let name: String
    let username: String
    let profile_image_url: String
    let description: String?
    let entities: TweetEntities?
    let verified: Bool
    let url: String
}

struct TweetIncludes: Codable {
    let media: [TweetMedia]?
    let tweets: [TweetData]?
    let polls: [TweetPoll]?
    let users: [TweetUser]?
}

struct TweetMedia: Codable {
    
    let identifier = UUID().uuidString
    
    struct MediaMetrics: Codable {
        let viewer_count: Int?
    }
    
    enum MediaType: String, Codable {
        case video, photo, animated_gif
    }
    
    struct MediaVariant: Codable {
        let url: String
    }
    
    let width: Int
    let height: Int
    let type: MediaType
    let url: String?
    let preview_image_url: String?
    let media_key: String
    let public_metrics: MediaMetrics?
    let variants: [MediaVariant]?
}

