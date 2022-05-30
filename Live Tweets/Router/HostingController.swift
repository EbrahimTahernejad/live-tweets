//
//  HostingController.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit

protocol HostingControllerProtocol: UIViewController {
    
}

class HostingController<ViewType: RootViewProtocol>: UIViewController, HostingControllerProtocol {
    let rootView: ViewType
    
    var isInitialAppear = true
    
    init(rootView: ViewType) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
        rootView.controller = self
    }
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootView.viewModel.didAppear(isInitialAppear)
        isInitialAppear = false
    }
    
    // Not needed
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
