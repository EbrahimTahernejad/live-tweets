//
//  UIApplication+TopController.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import UIKit


extension UIApplication {
    class func topViewController(base: UIViewController? = (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.keyWindow?.rootViewController) -> UIViewController? {
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
}
