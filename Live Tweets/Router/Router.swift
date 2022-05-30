//
//  Router.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit


protocol RouterProtocol: AnyObject {
    func present<ViewType: RootViewProtocol>(view ContentView: ViewType.Type, input: ViewType.ViewModel.Input, output: ViewType.ViewModel.Output, presentationStyle: UIModalPresentationStyle, transitionStyle: UIModalTransitionStyle, animated: Bool, resetContext: Bool, completion: (() -> Void)?)
    
    func navigate<ViewType: RootViewProtocol>(view ContentView: ViewType.Type, input: ViewType.ViewModel.Input, output: ViewType.ViewModel.Output, animated: Bool, completion: (() -> Void)?)
    
    func back(animated: Bool, forceClosePresentation: Bool, completion: (() -> Void)?)
    
    var bottomNavigationController: UINavigationController? { get }
}


class Router: RouterProtocol {
    private var history: [[HostingControllerProtocol]] = [[]]
    private var navigationControllers: [UINavigationController] = []
    
    var bottomNavigationController: UINavigationController? {
        return navigationControllers.first
    }
    
    private let viewProvider: ViewProviderProtocol
    
    init<ViewType: RootViewProtocol>(with ContentView: ViewType.Type, input: ViewType.ViewModel.Input, output: ViewType.ViewModel.Output, viewProvider: ViewProviderProtocol) {
        self.viewProvider = viewProvider
        viewProvider.update(router: self)
        let hostController = HostingController(rootView: viewProvider.provide(with: ContentView.self, input: input, output: output))
        let nav = NavigationController(rootViewController: hostController)
        navigationControllers = [nav]
        history = [[hostController]]
        nav.navDelegate = self
    }
    
    func present<ViewType: RootViewProtocol>(view ContentView: ViewType.Type, input: ViewType.ViewModel.Input, output: ViewType.ViewModel.Output, presentationStyle: UIModalPresentationStyle = .automatic, transitionStyle: UIModalTransitionStyle = .coverVertical, animated: Bool = true, resetContext: Bool = false, completion: (() -> Void)? = nil) {
        let hostController = HostingController(rootView: viewProvider.provide(with: ViewType.self, input: input, output: output))
        let nav = NavigationController(rootViewController: hostController)
        nav.navDelegate = self
        history.append([hostController])
        let current = navigationControllers.last
        navigationControllers.append(nav)
        nav.modalPresentationStyle = presentationStyle
        nav.modalTransitionStyle = transitionStyle
        current?.present(nav, animated: animated, completion: completion)
    }
    
    func navigate<ViewType: RootViewProtocol>(view ContentView: ViewType.Type, input: ViewType.ViewModel.Input, output: ViewType.ViewModel.Output, animated: Bool = true, completion: (() -> Void)? = nil) {
        let hostController = HostingController(rootView: viewProvider.provide(with: ViewType.self, input: input, output: output))
        var newHist = history.removeLast()
        newHist.append(hostController)
        history.append(newHist)
        navigationControllers.last?.pushViewController(hostController, animated: animated)
        completion?()
    }
    
    func back(animated: Bool = true, forceClosePresentation: Bool = false, completion: (() -> Void)? = nil) {
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
