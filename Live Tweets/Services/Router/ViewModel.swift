//
//  ViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import UIKit
import SwiftUI
import Combine

protocol BaseViewModelProtocol: ObservableObject {
    associatedtype Input: ViewModelInput
    associatedtype Output: ViewModelOutput
    func didLoad()
    static var inject: DependencyOptions { get set }
    init(input: Input, output: Output, dependencies: Dependencies)
}

class AnyViewModel {
    static var inject: DependencyOptions = []
    var cancelBag: Set<AnyCancellable> = .init()
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
