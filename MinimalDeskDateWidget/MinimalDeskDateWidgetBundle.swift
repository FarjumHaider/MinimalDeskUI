//
//  MinimalDeskDateWidgetBundle.swift
//  MinimalDeskDateWidget
//
//  Created by Rakib Hasan on 17/7/24.
//

import WidgetKit
import SwiftUI

@main
struct MinimalDeskDateWidgetBundle: WidgetBundle {
    var body: some Widget {
        MinimalDeskDateWidget()
        
    }
}

// MARK: - Utility Functions
func log(
    _ message: Any = "",
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    print(
        "[\((file as NSString).lastPathComponent.split(separator: ".").first ?? "File Name") - "
        + "[\(function)] - [\(line)] # \(message)"
    )
}


import AppIntents

//enum BackgroundTransparency: String, AppEnum {
//    case transparent, opaque
//    
//    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Background Transparency")
//    
//    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
//        .transparent: "Transparent",
//        .opaque: "Opaque"
//    ]
//}


enum WidgetBackgroundColor: String, AppEnum {
    case widDateColor = "#212121"
    case black = "#000000"
    case red = "#FF0000"
    case blue = "#0000FF"
    case green = "#00FF00"
    case yellow = "#FFFF00"
    case orange = "#FFA500"
    case purple = "#800080"

    // New colors
    case teal = "#008080"
    case pink = "#FFC0CB"
    case lime = "#BFFF00"
    case navy = "#000080"
    case gray = "#808080"
    case gold = "#FFD700"

    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Background Color")
    
    static var caseDisplayRepresentations: [Self: DisplayRepresentation] = [
        .widDateColor: "Primary",
        .black: "Black",
        .red: "Red",
        .blue: "Blue",
        .green: "Green",
        .yellow: "Yellow",
        .orange: "Orange",
        .purple: "Purple",
        .teal: "Teal",
        .pink: "Pink",
        .lime: "Lime",
        .navy: "Navy",
        .gray: "Gray",
        .gold: "Gold"
    ]
}
