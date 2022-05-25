//
//  String+Localization.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import SwiftUI

@dynamicMemberLookup
struct LocalizedString {
    subscript(dynamicMember member: String) -> String {
        return NSLocalizedString(member, tableName: LanguageService.shared.language.rawValue, bundle: .main, value: member, comment: member)
    }
}

extension String {
    static let localized = LocalizedString()
}

extension String {
    func params(_ parameters: [String:String]) -> String {
        var out = self
        for (ke, va) in parameters {
            out = out.replacingOccurrences(of: "{\(ke)}", with: va)
        }
        return out
    }
}

extension NSAttributedString {
    convenience init(string: String, style: FontStyle, color: Color) {
        self.init(string: string, attributes: [
            .foregroundColor: UIColor(color),
            .font: UIFont.systemFont(with: style)
        ])
    }
    func params(_ parameters: [String:NSAttributedString]) -> NSAttributedString {
        let out = NSMutableAttributedString(attributedString: self)
        for (ke, va) in parameters {
            while out.string.contains("{\(ke)}") {
                let range = (out.string as NSString).range(of: "{\(ke)}")
                out.replaceCharacters(in: range, with: va)
            }
        }
        return out
    }
}

