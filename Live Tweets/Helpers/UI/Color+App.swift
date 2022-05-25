//
//  Color+App.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import SwiftUI

@dynamicMemberLookup
struct AppColor {
    subscript(dynamicMember member: String) -> Color {
        return Color(member.camelCaseToKebabCase())
    }
}

extension Color {
    static let app = AppColor()
}
