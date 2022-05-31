//
//  PollTweetCellViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import RxCocoa
import RxSwift


struct PollTweetCellViewModelInput: ViewModelInput {
    let poll: BehaviorRelay<TweetPoll?> = .init(value: nil)
}

class PollTweetCellViewModel: BaseViewModel<PollTweetCellViewModelInput, EmptyIO> {
    
    override func didLoad() {
        super.didLoad()
        
        
    }
}
