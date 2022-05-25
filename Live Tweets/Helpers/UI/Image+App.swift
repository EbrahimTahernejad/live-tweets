//
//  Image+App.swift
//  Live Tweets
//
//  Created by Ebrahim Tahernejad on 3/2/1401 AP.
//

import SwiftUI

@dynamicMemberLookup
struct AppImage {
    subscript(dynamicMember member: String) -> Image {
        return Image(member.camelCaseToKebabCase())
    }
}

extension Image {
    static let app = AppImage()
}
