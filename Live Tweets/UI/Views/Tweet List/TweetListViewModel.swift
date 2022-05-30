//
//  TweetListViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation
import RxCocoa
import RxSwift
import Differentiator

enum TweetCellType {
    
    case normal(tweet: Tweet, retweeter: TweetUser?)
    case quoted(tweet: Tweet)
    case url(_ url: TweetURL)
    case media(_ media: TweetMedia)
    case poll(_ poll: TweetPoll)
}

extension TweetCellType: IdentifiableType, Equatable {
    
    typealias Identity = String
    var identity: String {
        switch self {
        case .normal(let tweet, _):
            return "N_" + tweet.data.id
        case .quoted(let tweet):
            return "Q_" + tweet.data.id
        case .url(let url):
            return "U_" + url.url
        case .media(let media):
            return "M_" + media.media_key
        case .poll(let poll):
            return "P_" + poll.id
        }
    }
    
    static func == (lhs: TweetCellType, rhs: TweetCellType) -> Bool {
        return lhs.identity == rhs.identity
    }
}


class TweetListViewModel: BaseViewModel<EmptyIO, EmptyIO> {
    
    override class var inject: DependencyOptions {
        [.router, .apiRulesService, .apiStreamService]
    }
    
    let searchBarFullScreen: BehaviorRelay<Bool> = .init(value: true)
    let filterText: BehaviorRelay<String> = .init(value: "")
    
    private let filterResults: BehaviorRelay<[Tweet]> = .init(value: [])
    private let streamOutput: PublishRelay<[Tweet]> = .init()
    let data: PublishRelay<[[TweetCellType]]> = .init()
    
    let streamEnabled: BehaviorRelay<Bool> = .init(value: false)
    
    override func didLoad() {
        super.didLoad()
        
        // Check if searchbar should be fullscreen
        filterResults
            .map { $0.count == 0 }
            .bind(to: searchBarFullScreen)
            .disposed(by: disposeBag)
        
        streamOutput.bind { lol in
            print(lol)
        }.disposed(by: disposeBag)
        
        // Check if our filter has more than 3 chars
        // Then wait 1.3 seconds to see if it changes again
        // If not we'll set a new rule for stream
        // Then connect to the stream if not, or disconnect
        // If the length is too short
        filterText
            .debounce(.milliseconds(1300), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .filter { $0.count > 3 }
            .flatMap(doFilter)
            .map { _ in return true }
            .bind(onNext: handleStreamState)
            .disposed(by: disposeBag)
        
        // Append stream output to filterResults
        streamOutput
            .map { [weak self] out in
                return out + (self?.filterResults.value ?? [])
            }
            .bind(to: filterResults)
            .disposed(by: disposeBag)
        
        filterResults
            .map(transform(tweets:))
            .bind(to: data)
            .disposed(by: disposeBag)
        
        dependencies.apiStreamService?.output.bind { [weak self] output in
            switch output {
            case .connecting:
                self?.streamEnabled.accept(true)
                print("API Connecting")
            case .disconnected:
                self?.streamEnabled.accept(false)
                print("API Disconnected")
            case .data(let data):
                self?.streamOutput.accept([data])
            }
        }.disposed(by: disposeBag)
        
    }
    
    private func transform(tweets: [Tweet]) -> [[TweetCellType]] {
        return tweets.map(transform(tweet:))
    }
    
    private func transform(tweet: Tweet) -> [TweetCellType] {
        let includes = tweet.includes
        // Make it var so we can recursively
        // search for the original tweet (if retweeted)
        var tweet = tweet.data
        // Find the retweeter if exists
        let retweeter =
            tweet
                .referenced_tweets?
                .contains(where: { $0.type == .retweeted }) ?? false
            ?
            includes?
                .users?
                .first(where: { $0.id == tweet.author_id })
            :
            nil
        // Search for the original tweet
        while
            // If there is no tweet related by retweeting,
            // We've found the original tweet
            let ref = tweet.referenced_tweets?.first(where: { $0.type == .retweeted }),
            let newTweet = includes?.tweets?.first(where: { $0.id == ref.id })
        {
            tweet = newTweet
        }
        
        var after: [TweetCellType] = []
        // Check if there is any qouted tweet to add
        if
            let ref = tweet.referenced_tweets?.first(where: { $0.type == .quoted }),
            let found = includes?.tweets?.first(where: { $0.id == ref.id })
        {
            after.append(
                .quoted(tweet: .init(data: found, includes: includes))
            )
        }
        
        // Check if there are any medias and show them
        var before: [TweetCellType] = []
        if
            let medias = tweet.attachments?.media_keys?
                .compactMap({ key in
                    return includes?.media?.first(where: { $0.media_key == key })
                })
        {
            before.append(contentsOf: transform(medias: medias))
        }
        
        // Check for first url that has metadata
        // And append it
        if
            let url = tweet.entities?.urls?.first(where: { $0.title != nil })
        {
            before.append(.url(url))
        }
        
        // Having no retweeter means the current tweet
        // Might not be the first one
        if
            retweeter != nil,
            let ref = tweet.referenced_tweets?.first(where: { $0.type == .replied_to }),
            let parent = includes?.tweets?.first(where: { $0.id == ref.id })
        {
            before.append(
                contentsOf: transform(tweet: .init(data: parent, includes: includes))
            )
        }
        
        // Return the "section"
        return before + [.normal(tweet: Tweet(data: tweet, includes: includes), retweeter: retweeter)] + after
    }
    
    private func transform(medias: [TweetMedia]) -> [TweetCellType] {
        // For now let's return the first one only
        guard let media = medias.first else { return [] }
        return [.media(media)]
    }
    
    private func handleStreamState(_ enabled: Bool) {
        if enabled {
            dependencies.apiStreamService?.connect()
        } else {
            dependencies.apiStreamService?.disconnect()
        }
    }
    
    func disconnect() {
        streamEnabled.accept(false)
    }
    
    private func doFilter(_ text: String) -> Observable<RulesData> {
        dependencies.apiRulesService?.reset(rules: [
            .init(value: text, tag: nil, id: nil)
        ]) ?? Observable.error(DIError.dependecyLost)
    }
    
}
