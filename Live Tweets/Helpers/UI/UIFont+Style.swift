//
//  UIFont+Style.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import UIKit


struct FontStyle {
    let fontSize: CGFloat
    let fontWeight: UIFont.Weight
}

extension UIFont {
    static func systemFont(style: FontStyle) -> UIFont {
        return UIFont.systemFont(ofSize: style.fontSize, weight: style.fontWeight)
    }
}
