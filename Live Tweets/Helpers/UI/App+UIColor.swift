//
//  App+UIColor.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit

@dynamicMemberLookup
struct AppUIColor {
    subscript(dynamicMember member: String) -> UIColor {
        return UIColor(named: member.camelCaseToKebabCase()) ?? .clear
    }
}

extension UIColor {
    static let app = AppUIColor()
}
