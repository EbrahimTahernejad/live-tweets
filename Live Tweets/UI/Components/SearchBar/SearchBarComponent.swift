//
//  SearchBarComponent.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/4/1401 AP.
//

import SwiftUI
import Combine

struct SearchBarComponent: RootView {
    
    @ObservedObject var viewModel: ViewModel
    
    var body: some View {
        VStack {
            HStack {
                TextField("Hello", text: $viewModel.filterText).textFieldStyle(.plain).fontStyle(.normal)
            }
        }.frame(maxHeight: 100, alignment: .top)
    }
    
    
}
