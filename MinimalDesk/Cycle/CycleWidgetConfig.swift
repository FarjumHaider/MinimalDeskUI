//
//  CycleWidgetConfig.swift
//  MinimalDesk
//
//  Created by Haider on 20/2/26.
//

import Foundation
import SwiftUI

struct CycleWidgetConfig: Codable {
    var fontType: String
    var fontWeight: String
    var fontSize: Double
    var fontColor: String
    var backgroundColor: String
    var alignment: String
    var spacing: CGFloat
    var maxNumberOfApps: Int
    var caseText: String
    
    static var defaultConfig: CycleWidgetConfig = .init(
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
