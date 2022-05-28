//
//  RouteData.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import UIKit
import SwiftUI
import Combine

struct EmptyViewModelIO: ViewModelInput, ViewModelOutput {
    
}

protocol ViewModelInput {
    
}

protocol ViewModelOutput {
    
}

extension ViewModelInput {
    typealias Empty = EmptyViewModelIO
}

extension ViewModelOutput {
    typealias Empty = EmptyViewModelIO
}
