//
//  QuoteTweetCellViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import RxCocoa
import RxSwift

struct QuoteTweetCellViewModelInput: ViewModelInput {
    let tweet: BehaviorRelay<Tweet?> = .init(value: nil)
}

class QuoteTweetCellViewModel: BaseViewModel<QuoteTweetCellViewModelInput, EmptyIO> {
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

