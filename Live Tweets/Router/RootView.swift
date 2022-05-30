//
//  RootView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit
import RxSwift

protocol RootViewProtocol: UIView {
    associatedtype ViewModel: BaseViewModelProtocol
    var viewModel: ViewModel { get }
    var viewProvider: ViewProviderProtocol? { get }
    var controller: UIViewController? { get set }
    init(viewModel: ViewModel, viewProvider: ViewProviderProtocol)
}

protocol RootViewSetupProtocol: RootViewProtocol {
    func loadSubviews()
    func layout()
    func setupViewModel()
}

class RootView<ViewModel: BaseViewModelProtocol>: UIView, RootViewProtocol, RootViewSetupProtocol {
    
    weak var controller: UIViewController? {
        didSet {
            if let controller = controller {
                setup(controller: controller)
            }
        }
    }
    weak var viewProvider: ViewProviderProtocol?
    let viewModel: ViewModel
    
    let disposeBag = DisposeBag()
    
    required init(viewModel: ViewModel, viewProvider: ViewProviderProtocol) {
        self.viewProvider = viewProvider
        self.viewModel = viewModel
        super.init(frame: .zero)
        
        setup()
        viewModel.didLoad()
    }
    
    func setup(controller: UIViewController) {
        
    }
    
    private func setupTapGesture() {
        let tap = UITapGestureRecognizer()
        tap.cancelsTouchesInView = false
        addGestureRecognizer(tap)
        tap.rx.event.bind { [unowned self] _ in
            endEditing(true)
        }.disposed(by: disposeBag)
    }
    
    private func setup() {
        setupTapGesture()
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

class RootCellView<ViewModel: BaseViewModelProtocol>: UITableViewCell, RootViewProtocol, RootViewSetupProtocol {
    weak var controller: UIViewController?
    weak var viewProvider: ViewProviderProtocol?
    let viewModel: ViewModel
    
    class var reuseIdentifier: String {
        return "RootCellView"
    }
    
    let disposeBag: DisposeBag = DisposeBag()
    
    required init(viewModel: ViewModel, viewProvider: ViewProviderProtocol) {
        self.viewProvider = viewProvider
        self.viewModel = viewModel
        super.init(style: .default, reuseIdentifier: Self.reuseIdentifier)
        
        setup()
        viewModel.didLoad()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
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
}
