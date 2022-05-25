//
//  NavigationController.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import UIKit
import SwiftUI
import Combine


protocol NavigationControllerDelegate: AnyObject {
    func didDismiss()
    func didPop()
}

class NavigationController: UINavigationController {
    weak var navDelegate: NavigationControllerDelegate?
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if isBeingDismissed {
            navDelegate?.didDismiss()
        }
    }
    
    override func popViewController(animated: Bool) -> UIViewController? {
        let vc =  super.popViewController(animated: animated)
        navDelegate?.didPop()
        return vc
    }
}
