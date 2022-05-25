//
//  Text+Style.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import UIKit
import SwiftUI

struct FontStyle {
    let fontSize: CGFloat
    let fontWeight: UIFont.Weight
}

extension UIFont {
    static func systemFont(with style: FontStyle) -> UIFont {
        return UIFont.systemFont(ofSize: style.fontSize, weight: style.fontWeight)
    }
}

extension Font {
    static func system(with style: FontStyle) -> Font {
        return Font.system(size: style.fontSize, weight: style.fontWeight)
    }
    
    static func system(size: CGFloat, weight: UIFont.Weight) -> Font {
        return Font(UIFont.systemFont(ofSize: size, weight: weight) as CTFont)
    }
}

extension String {
    var text: Text {
        return Text(self)
    }
}

extension Text {
    init(_ astring: NSAttributedString) {
        self.init("")
        
        astring.enumerateAttributes(in: NSRange(location: 0, length: astring.length), options: []) { (attrs, range, _) in
            
            var t = Text(astring.attributedSubstring(from: range).string)

            if let color = attrs[NSAttributedString.Key.foregroundColor] as? UIColor {
                t  = t.foregroundColor(Color(color))
            }

            if let font = attrs[NSAttributedString.Key.font] as? UIFont {
                t  = t.font(.init(font))
            }

            if let kern = attrs[NSAttributedString.Key.kern] as? CGFloat {
                t  = t.kerning(kern)
            }
            
            
            if let striked = attrs[NSAttributedString.Key.strikethroughStyle] as? NSNumber, striked != 0 {
                if let strikeColor = (attrs[NSAttributedString.Key.strikethroughColor] as? UIColor) {
                    t = t.strikethrough(true, color: Color(strikeColor))
                } else {
                    t = t.strikethrough(true)
                }
            }
            
            if let baseline = attrs[NSAttributedString.Key.baselineOffset] as? NSNumber {
                t = t.baselineOffset(CGFloat(baseline.floatValue))
            }
            
            if let underline = attrs[NSAttributedString.Key.underlineStyle] as? NSNumber, underline != 0 {
                if let underlineColor = (attrs[NSAttributedString.Key.underlineColor] as? UIColor) {
                    t = t.underline(true, color: Color(underlineColor))
                } else {
                    t = t.underline(true)
                }
            }
            
            self = self + t
            
        }
    }

}

extension NSAttributedString {
    var text: Text {
        return Text(self)
    }
}

