//
//  String+LocalizationParameters.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/9/1401 AP.
//

import Foundation


extension String {
    func params(_ parameters: [String:String]) -> String {
        var out = self
        for (ke, va) in parameters {
            out = out.replacingOccurrences(of: "{\(ke)}", with: va)
        }
        return out
    }
}
