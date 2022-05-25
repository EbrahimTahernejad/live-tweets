//
//  InitialViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/4/1401 AP.
//

import Combine

extension InitialView {
    class ViewModel: BaseViewModel<EmptyRouteData> {
                
        required init(data: EmptyRouteData, router: Router?) {
            super.init(data: data, router: router)
        }
        
        override func didLoad() {
            print("Didload")
        }
        
    }
}
