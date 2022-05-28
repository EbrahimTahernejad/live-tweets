//
//  RootView.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import SwiftUI
import UIKit
import Combine


protocol RootView: View {
    associatedtype ViewModel: BaseViewModelProtocol
    var viewModel: ViewModel { get set }
    init(viewModel: ViewModel)
}
