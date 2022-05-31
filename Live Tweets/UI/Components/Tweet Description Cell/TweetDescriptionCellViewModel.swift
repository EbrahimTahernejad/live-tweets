//
//  TweetDescriptionCellViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import RxCocoa
import RxSwift

struct TweetDescriptionCellViewModelInput: ViewModelInput {
    let metrics: BehaviorRelay<TweetMetrics?> = .init(value: nil)
}

class TweetDescriptionCellViewModel: BaseViewModel<TweetDescriptionCellViewModelInput, EmptyIO> {
        
    let retweetCount: BehaviorRelay<Int?> = .init(value: nil)
    let replyCount: BehaviorRelay<Int?> = .init(value: nil)
    let likeCount: BehaviorRelay<Int?> = .init(value: nil)
    let quoteCount: BehaviorRelay<Int?> = .init(value: nil)
    
    override func didLoad() {
        super.didLoad()
        
        input.metrics.map { $0?.retweet_count }
            .bind(to: retweetCount).disposed(by: disposeBag)
        input.metrics.map { $0?.like_count }
            .bind(to: likeCount).disposed(by: disposeBag)
        input.metrics.map { $0?.quote_count }
            .bind(to: quoteCount).disposed(by: disposeBag)
        input.metrics.map { $0?.reply_count }
            .bind(to: replyCount).disposed(by: disposeBag)
        
    }
}
