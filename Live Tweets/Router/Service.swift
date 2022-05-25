//
//  Service.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import Foundation
import Combine

class Service: ObservableObject {
    var cancelBag: Set<AnyCancellable> = .init()
}
