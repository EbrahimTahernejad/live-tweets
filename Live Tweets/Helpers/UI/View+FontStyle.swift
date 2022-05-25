//
//  View+FontStyle.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import SwiftUI

extension View {
    func fontStyle(_ style: FontStyle) -> some View {
        return font(Font.system(with: style))
    }
}
