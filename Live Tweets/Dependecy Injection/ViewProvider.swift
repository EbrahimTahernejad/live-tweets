//
//  ViewProvider.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation
import UIKit

protocol ViewProviderProtocol: AnyObject {
    var dependencies: DependenciesStrong { get }
    init(dependencies: DependenciesStrong)
    func update(router: Router)
    func provide<ViewType: RootViewProtocol>(with ContentView: ViewType.Type, input: ViewType.ViewModel.Input, output: ViewType.ViewModel.Output) -> ViewType
}

class ViewProvider: ViewProviderProtocol {
    
    private(set) var dependencies: DependenciesStrong
    
    required init(dependencies: DependenciesStrong) {
        self.dependencies = dependencies
    }
    
    func update(router: Router) {
        dependencies.router = router
    }
    
    private func buildDependencies(_ inject: DependencyOptions) -> Dependencies {
        var dependencies = Dependencies()
        if inject.contains(.router) {
            dependencies.router = self.dependencies.router
        }
        if inject.contains(.languageService) {
            dependencies.languageService = self.dependencies.languageService
        }
        if inject.contains(.apiRulesService) {
            dependencies.apiRulesService = self.dependencies.apiRulesService
        }
        return dependencies
    }
    
    func provide<ViewType: RootViewProtocol>(with ContentView: ViewType.Type, input: ViewType.ViewModel.Input, output: ViewType.ViewModel.Output) -> ViewType {
        return ViewType.init(viewModel: .init(input: input, output: output, dependencies: buildDependencies(ViewType.ViewModel.inject)), viewProvider: self)
    }
}
