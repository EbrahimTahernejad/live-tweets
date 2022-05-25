//
//  ViewModel.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import UIKit
import SwiftUI
import Combine

protocol BaseViewModelProtocol: ObservableObject {
    associatedtype InputData: RouteData
    func didLoad()
    var router: Router? { get set }
    init(data: InputData, router: Router?)
}

class BaseViewModel<InputData: RouteData>: BaseViewModelProtocol {
    weak var router: Router?
    var cancelBag: Set<AnyCancellable> = .init()
    func didLoad() {
        
    }
    required init(data: InputData, router: Router?) {
        self.router = router
    }
}
