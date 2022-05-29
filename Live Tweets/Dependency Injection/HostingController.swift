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

class HostingController<T: RootView>: UIHostingController<AnyView>, HostController {
    @Published var state: HostingControllerState = .notLoaded
    
    var viewModel: T.ViewModel
    
    init(rootView: T, viewProvider: ViewProviderProtocol) {
        viewModel = rootView.viewModel
        super.init(rootView: AnyView(rootView.environment(\.locale, Locale(identifier: viewProvider.dependencies.languageService?.language.rawValue ?? "en")).environment(\.viewProvider, viewProvider)))
    }
    
    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if state != .loaded {
            state = .loaded
            viewModel.didLoad()
        }
    }
}

