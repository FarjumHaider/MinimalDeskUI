//
//  FavAppWidgetConfig.swift
//  MinimalDesk
//
//  Created by Rakib Hasan on 25/9/24.
//

import Foundation
import SwiftUI

struct FavAppWidgetConfig: Codable {
    var fontType: String
    var fontWeight: String
    var fontSize: Double
    var fontColor: String
    var backgroundColor: String
    var alignment: String
    var spacing: CGFloat
    var maxNumberOfApps: Int
    var caseText: String
    
    static var defaultConfig: FavAppWidgetConfig = .init(
        fontType: "Impact",
        fontWeight: "regular",
        fontSize: 30,
        fontColor: "#000000",
        backgroundColor: "#FFFFFF",
        alignment: "left",
        spacing: 16,
        maxNumberOfApps: 5,
        caseText: "default"
    )
}

struct FavAppWidgetConfig1: Codable {
    var fontColor: String
    var backgroundColor: String
}

struct DateConfig: Codable {
    var arr: [FavAppWidgetConfig1]

    static var defaultConfig: DateConfig = .init (
        arr: [
            FavAppWidgetConfig1(fontColor: "#000000", backgroundColor: "#FFFFFF"),
            FavAppWidgetConfig1(fontColor: "#000000", backgroundColor: "#FFFFFF"),
            FavAppWidgetConfig1(fontColor: "#000000", backgroundColor: "#FFFFFF"),
            FavAppWidgetConfig1(fontColor: "#000000", backgroundColor: "#FFFFFF"),
            FavAppWidgetConfig1(fontColor: "#000000", backgroundColor: "#FFFFFF"),
            FavAppWidgetConfig1(fontColor: "#000000", backgroundColor: "#FFFFFF"),
            FavAppWidgetConfig1(fontColor: "#000000", backgroundColor: "#FFFFFF"),
            FavAppWidgetConfig1(fontColor: "#000000", backgroundColor: "#FFFFFF")
        ]
    )
}
