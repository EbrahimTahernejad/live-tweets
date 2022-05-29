//
//  ViewProvider.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/7/1401 AP.
//

import Foundation
import SwiftUI

protocol ViewProviderProtocol {
    var dependencies: Dependencies { get }
    init(dependencies: Dependencies)
    func update(router: Router)
    func provide<ViewType: RootView>(with ContentView: ViewType.Type, input: ViewType.ViewModel.Input, output: ViewType.ViewModel.Output) -> ViewType
}

private struct ViewProviderKey: EnvironmentKey {
    static let defaultValue = ViewProvider(dependencies: .init()) as ViewProviderProtocol
}

extension EnvironmentValues {
  var viewProvider: ViewProviderProtocol {
    get { self[ViewProviderKey.self] }
    set { self[ViewProviderKey.self] = newValue }
  }
}

class ViewProvider: ViewProviderProtocol {
    
    private(set) var dependencies: Dependencies
    
    required init(dependencies: Dependencies) {
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
    
    func provide<ViewType: RootView>(with ContentView: ViewType.Type, input: ViewType.ViewModel.Input, output: ViewType.ViewModel.Output) -> ViewType {
        ViewType.init(viewModel: .init(input: input, output: output, dependencies: buildDependencies(ViewType.ViewModel.inject)))
    }
}
