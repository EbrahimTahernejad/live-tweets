//
//  TweetListView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/4/1401 AP.
//

import SwiftUI


struct TweetListView: RootView {
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
    }
    
    
    @ObservedObject var viewModel: ViewModel
    @Environment(\.viewProvider) var viewProvider: ViewProviderProtocol
    
    var body: some View {
        ZStack(alignment: .top) {
            viewProvider.provide(
                with: SearchBarComponent.self,
                input: .init(
                    fullScreen: viewModel.$fullScreenSearch.eraseToAnyPublisher()
                ),
                output: .init(
                    filterText: viewModel.filterTextInput()
                )
            )
        }
        
    }
}

struct TweetListView_Previews: PreviewProvider {
    static var previews: some View {
        TweetListView(viewModel: .init(input: .init(), output: .init(), dependencies: .init()))
    }
}

