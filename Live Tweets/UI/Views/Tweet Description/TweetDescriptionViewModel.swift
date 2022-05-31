//
//  TweetDescriptionViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import RxCocoa

struct TweetDescriptionViewModelInput: ViewModelInput {
    let section: SectionOfData
}

class TweetDescriptionViewModel: BaseViewModel<TweetDescriptionViewModelInput, EmptyIO> {
    
    class override var inject: DependencyOptions {
        [.router, .languageService]
    }
    
    override func didLoad() {
        super.didLoad()
        
        
    }
}
