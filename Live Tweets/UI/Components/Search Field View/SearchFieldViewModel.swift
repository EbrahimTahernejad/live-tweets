//
//  SearchFieldViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import RxCocoa


struct SearchFieldViewModelOutput: ViewModelOutput {
    let query: BehaviorRelay<String?> = .init(value: nil)
}


class SearchFieldViewModel: BaseViewModel<EmptyIO, SearchFieldViewModelOutput> {
    class override var inject: DependencyOptions {
        return [.router, .languageService]
    }
}
