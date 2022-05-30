//
//  Service.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation
import RxSwift


protocol ServiceProtocol: AnyObject {
    
}

class Service: NSObject, ServiceProtocol {
    let disposeBag: DisposeBag = .init()
}
