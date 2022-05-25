//
//  ContentView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import SwiftUI

struct ContentView: RootView {
    
    
    class ViewModel: BaseViewModel<EmptyRouteData> {
        required init(data: EmptyRouteData, router: Router?) {
            super.init(data: data, router: router)
        }
        
        override func didLoad() {
            
        }
    }
    
    var viewModel: ViewModel
    
    var body: some View {
        Text("Hello, world!")
            .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(viewModel: .init(data: .init(), router: nil))
    }
}
