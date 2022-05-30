//
//  App+UIImage.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit

@dynamicMemberLookup
struct AppUIImage {
    subscript(dynamicMember member: String) -> UIImage {
        return UIImage(named: member.camelCaseToKebabCase()) ?? .init()
    }
}

extension UIImage {
    static let app = AppUIImage()
}

