//
//  UIApplication+TopController.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import UIKit


extension UIApplication {
    class func topViewController(base: UIViewController? = UIApplication.shared.windows.first?.rootViewController) -> UIViewController? {
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
