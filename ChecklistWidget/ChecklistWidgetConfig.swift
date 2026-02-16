//
//  ChecklistWidgetConfig.swift
//  MinimalDesk
//
//  Created by Haider on 8/2/26.
//

import Foundation
import SwiftUI

struct ChecklistWidgetConfig: Codable {
    var fontType: String
    var fontWeight: String
    var fontSize: Double
    var fontColor: String
    var backgroundColor: String
    var alignment: String
    var spacing: CGFloat
    var maxNumberOfApps: Int
    var caseText: String
    
    static var defaultConfig: ChecklistWidgetConfig = .init(
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
