//
//  UITweetCellViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import RxCocoa


struct URLTweetCellViewModelInput: ViewModelInput {
    let url: BehaviorRelay<TweetURL?> = .init(value: nil)
}

class URLTweetCellViewModel: BaseViewModel<URLTweetCellViewModelInput, EmptyIO> {
    
    override func didLoad() {
        super.didLoad()
        
        
    }
}
