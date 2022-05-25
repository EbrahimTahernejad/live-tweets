//
//  HostingController.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import UIKit
import SwiftUI
import Combine

enum HostingControllerState {
    case notLoaded, loaded
}

protocol HostController: UIViewController {
    
}

class HostingController<Content>: UIHostingController<Content>, HostController, ObservableObject where Content: RootView {
    @Published var state: HostingControllerState = .notLoaded
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if state != .loaded {
            state = .loaded
            rootView.viewModel.didLoad()
        }
    }
}

