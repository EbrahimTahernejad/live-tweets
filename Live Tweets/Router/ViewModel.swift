//
//  ViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import RxSwift
import Foundation

protocol ViewModelInput {
    
}

protocol ViewModelOutput {
    
}

protocol BaseViewModelProtocol: ObservableObject {
    associatedtype Input: ViewModelInput
    associatedtype Output: ViewModelOutput
    func didLoad()
    static var inject: DependencyOptions { get }
    init(input: Input, output: Output, dependencies: Dependencies)
}

class AnyViewModel {
    class var inject: DependencyOptions { [] }
    var disposeBag: DisposeBag = .init()
    let dependencies: Dependencies
    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }
}

class BaseViewModel<Input: ViewModelInput, Output: ViewModelOutput>: AnyViewModel, BaseViewModelProtocol {
    func didLoad() {
        
    }
    required init(input: Input, output: Output, dependencies: Dependencies) {
        super.init(dependencies: dependencies)
    }
}
