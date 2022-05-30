//
//  NormalTweetCellViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import RxCocoa


struct NormalTweetCellViewModelInput: ViewModelInput {
    let retweeter: BehaviorRelay<TweetUser?> = .init(value: nil)
    let tweet: BehaviorRelay<Tweet?> = .init(value: nil)
}

class NormalTweetCellViewModel: BaseViewModel<NormalTweetCellViewModelInput, EmptyIO> {
    let author: BehaviorRelay<TweetUser?> = .init(value: nil)
    
    override func didLoad() {
        super.didLoad()
        
        input.tweet
            .map { (tweet: Tweet?) -> TweetUser? in
                guard let tweet = tweet else { return nil }
                return tweet.includes?.users?.first(where: { $0.id == tweet.data.author_id })
            }
            .bind(to: author)
            .disposed(by: disposeBag)
    }
}
