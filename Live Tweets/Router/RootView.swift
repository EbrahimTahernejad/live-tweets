//
//  RootView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit

protocol RootViewProtocol: UIView {
    associatedtype ViewModel: BaseViewModelProtocol
    var viewModel: ViewModel { get }
    var viewProvider: ViewProviderProtocol? { get }
    init(viewModel: ViewModel, viewProvider: ViewProviderProtocol)
}

class RootView<ViewModel: BaseViewModelProtocol>: UIView, RootViewProtocol {
    weak var viewProvider: ViewProviderProtocol?
    let viewModel: ViewModel
    
    required init(viewModel: ViewModel, viewProvider: ViewProviderProtocol) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setup()
        viewModel.didLoad()
    }
    
    func setup() {
        loadSubviews()
        layout()
        setupViewModel()
    }
    
    func loadSubviews() {
        
    }
    
    func layout() {
        
    }
    
    func setupViewModel() {
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
