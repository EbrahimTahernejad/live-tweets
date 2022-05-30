//
//  InitialViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit

class InitialViewModel: BaseViewModel<EmptyIO, EmptyIO> {
    override func didLoad() {
        super.didLoad()
        
        
    }
    
    override func didAppear(_ initial: Bool) {
        super.didAppear(initial)
        
        print("appear")
        
        guard initial else { return }
        dependencies.router?.present(view: TweetListView.self, input: .init(), output: .init(), presentationStyle: .overFullScreen, transitionStyle: .crossDissolve, animated: true, resetContext: false, completion: nil)
    }
}
