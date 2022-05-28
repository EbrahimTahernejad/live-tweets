//
//  TweetListView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/4/1401 AP.
//

import SwiftUI


struct TweetListView: RootView {
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        ZStack(alignment: .top) {
            HStack {
                TextField("Hello", text: $viewModel.filterText).textFieldStyle(.plain).fontStyle(.normal)
            }.frame(maxHeight: 100)
            
            
        }
        
    }
}

struct TweetListView_Previews: PreviewProvider {
    static var previews: some View {
        TweetListView(viewModel: .init(input: .init(), output: .init(), dependencies: .init()))
    }
}

