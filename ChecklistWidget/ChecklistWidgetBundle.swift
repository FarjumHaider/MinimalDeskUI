//
//  ChecklistWidgetBundle.swift
//  ChecklistWidget
//
//  Created by Haider on 13/2/26.
//

import WidgetKit
import SwiftUI

@main
struct ChecklistWidgetBundle: WidgetBundle {
    var body: some Widget {
        ChecklistWidget(cardIndex: 0)
        ChecklistWidget(cardIndex: 1)
        ChecklistWidget(cardIndex: 2)
        ChecklistWidget(cardIndex: 3)
        ChecklistWidget(cardIndex: 4)
    }
}
