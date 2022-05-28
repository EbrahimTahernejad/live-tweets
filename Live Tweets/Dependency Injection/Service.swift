//
//  Service.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import Foundation
import Combine

protocol ServiceProtocol: AnyObject {
    
}

class Service: ServiceProtocol {
    var cancelBag: Set<AnyCancellable> = .init()
}
