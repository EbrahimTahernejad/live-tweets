//
//  SearchBarComponentModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Combine


extension SearchBarComponent {
    
    struct VMInput: ViewModelInput {
        let fullScreen: AnyPublisher<Bool, Never>
    }
    
    struct VMOutput: ViewModelOutput {
        let filterText: PassthroughSubject<String, Never>
    }
    
    class ViewModel: BaseViewModel<VMInput, VMOutput> {
        
        @Published var fullScreen: Bool = false
        @Published var filterText: String = ""
        
        required init(input: Input, output: Output, dependencies: Dependencies) {
            super.init(input: input, output: output, dependencies: dependencies)
            
            print("VMM")
            
            input.fullScreen.assign(to: &$fullScreen)
            $filterText.sink { [output] text in
                output.filterText.send(text)
            }.store(in: &cancelBag)
        }
        
        override func didLoad() {
            
        }
        
    }
}
