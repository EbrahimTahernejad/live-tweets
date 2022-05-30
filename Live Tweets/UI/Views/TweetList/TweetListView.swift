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
            VStack {
                HStack {
                    TextField("Hello", text: $viewModel.filterText).textFieldStyle(.plain).fontStyle(.normal)
                    Button {
                        viewModel.dependencies.apiRulesService?.reset(rules: [Rule.init(value: viewModel.filterText, tag: nil, id: nil)]).sink(receiveCompletion: { comp in
                            switch comp {
                            case .failure(let e):
                                print("F bruh \(e)")
                            case .finished:
                                print("finished")
                            }
                        }, receiveValue: { val in
                            print("Val \(val)")
                        }).store(in: &viewModel.cancelBag)
                    } label: {
                        Text("Do Stuff")
                    }
                }
            }.frame(maxHeight: 100, alignment: .top)
        }
        
    }
}

struct TweetListView_Previews: PreviewProvider {
    static var previews: some View {
        TweetListView(viewModel: .init(input: .init(), output: .init(), dependencies: .init()))
    }
}

