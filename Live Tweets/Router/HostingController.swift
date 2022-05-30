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
    
    init(rootView: ViewType) {
        self.rootView = rootView
        super.init(nibName: nil, bundle: nil)
    }
    
    override func loadView() {
        view = rootView
    }
    
    // Not needed
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
