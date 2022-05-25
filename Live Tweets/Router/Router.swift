//
//  Router.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import UIKit
import SwiftUI
import Combine


class Router {
    private var history: [[HostController]] = [[]]
    private var navigationControllers: [UINavigationController] = []
    
    var bottomNavigationController: UINavigationController? {
        return navigationControllers.first
    }
    
    init<ViewType: RootView>(with ContentView: ViewType.Type, data: ViewType.ViewModel.InputData) {
        let hostController = HostingController(rootView: ContentView.init(viewModel: ContentView.ViewModel.init(data: data, router: self)))
        let nav = NavigationController(rootViewController: hostController)
        navigationControllers = [nav]
        history = [[hostController]]
        nav.navDelegate = self
    }
    
    func present<ViewType: RootView>(view ContentView: ViewType.Type, with data: ViewType.ViewModel.InputData, presentationStyle: UIModalPresentationStyle = .automatic, transitionStyle: UIModalTransitionStyle = .coverVertical, animated: Bool = true, resetContext: Bool = false, completion: (() -> Void)? = nil) {
        let hostController = HostingController(rootView: ContentView.init(viewModel: ContentView.ViewModel.init(data: data, router: self)))
        let nav = NavigationController(rootViewController: hostController)
        nav.navDelegate = self
        history.append([hostController])
        let current = navigationControllers.last
        navigationControllers.append(nav)
        nav.modalPresentationStyle = presentationStyle
        nav.modalTransitionStyle = transitionStyle
        current?.present(nav, animated: animated, completion: completion)
    }
    
    func navigate<ViewType: RootView>(view ContentView: ViewType.Type, with data: ViewType.ViewModel.InputData, animated: Bool = true, completion: (() -> Void)?) {
        let hostController = HostingController(rootView: ContentView.init(viewModel: ContentView.ViewModel.init(data: data, router: self)))
        var newHist = history.removeLast()
        newHist.append(hostController)
        history.append(newHist)
        navigationControllers.last?.pushViewController(hostController, animated: animated)
        completion?()
    }
    
    func back(animated: Bool = true, forceClosePresentation: Bool = false, completion: (() -> Void)?) {
        if forceClosePresentation || (history.last?.count ?? 0) < 2 {
            guard navigationControllers.count > 1 else {
                completion?()
                return
            }
            navigationControllers.removeLast().dismiss(animated: animated, completion: completion)
        } else {
            guard (history.last?.count ?? 0) > 1 else {
                completion?()
                return
            }
            navigationControllers.last?.popViewController(animated: animated)
            completion?()
        }
    }
}

extension Router: NavigationControllerDelegate {
    func didDismiss() {
        let _ = navigationControllers.removeLast()
        let _ = history.removeLast()
    }
    
    func didPop() {
        var newHist = history.removeLast()
        let _ = newHist.removeLast()
        history.append(newHist)
    }
}
