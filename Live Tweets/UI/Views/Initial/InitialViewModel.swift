//
//  InitialViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/4/1401 AP.
//

import Foundation
import Combine

extension InitialView {
    @MainActor class ViewModel: BaseViewModel<ViewModelInput.Empty, ViewModelOutput.Empty> {
        override class var inject: DependencyOptions { [.router] }
        
        override func didLoad() {
            dependencies.router?.present(view: TweetListView.self, input: .init(), output: .init(), presentationStyle: .overFullScreen, transitionStyle: .crossDissolve, animated: true, resetContext: false, completion: nil)
        }
        
    }
}
