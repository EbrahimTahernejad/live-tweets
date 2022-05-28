//
//  TweetListViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/4/1401 AP.
//

import Foundation
import Combine

extension TweetListView {
    @MainActor class ViewModel: BaseViewModel<ViewModelInput.Empty, ViewModelOutput.Empty> {
        
        @Published var filterText: String = ""
        
        required init(input: Input, output: Output, dependencies: Dependencies) {
            super.init(input: input, output: output, dependencies: dependencies)
        }
        
    }
}
