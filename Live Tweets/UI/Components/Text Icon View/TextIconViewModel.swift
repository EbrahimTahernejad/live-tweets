//
//  TextIconViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/10/1401 AP.
//

import RxCocoa
import RxSwift

struct TextIconViewModelInput: ViewModelInput {
    let image: BehaviorRelay<UIImage?> = .init(value: nil)
    let text: BehaviorRelay<String?> = .init(value: nil)
}

class TextIconViewModel: BaseViewModel<TextIconViewModelInput, EmptyIO> {
        
    
    
}
