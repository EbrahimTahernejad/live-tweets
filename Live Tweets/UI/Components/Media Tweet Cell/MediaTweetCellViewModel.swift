//
//  MediaTweetCellViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import RxCocoa


struct MediaTweetCellViewModelInput: ViewModelInput {
    let media: BehaviorRelay<TweetMedia?> = .init(value: nil)
}

class MediaTweetCellViewModel: BaseViewModel<MediaTweetCellViewModelInput, EmptyIO> {
    
    override func didLoad() {
        super.didLoad()
        
        
    }
}
