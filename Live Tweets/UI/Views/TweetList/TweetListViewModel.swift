//
//  TweetListViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/4/1401 AP.
//

import Foundation
import Combine

extension TweetListView {
    class ViewModel: BaseViewModel<ViewModelInput.Empty, ViewModelOutput.Empty> {
        
        override class var inject: DependencyOptions {
            [.router, .apiRulesService]
        }
        
        @Published var filterText: String = ""
        @Published var fullScreenSearch: Bool = true
        
        required init(input: Input, output: Output, dependencies: Dependencies) {
            super.init(input: input, output: output, dependencies: dependencies)
            
            $filterText.sink { text in
                print("Text \(text)")
            }.store(in: &cancelBag)
        }
        
        func filterTextInput() -> PassthroughSubject<String, Never> {
            let subject = PassthroughSubject<String, Never>()
            subject.assign(to: &$filterText)
            return subject
        }
        
    }
}
