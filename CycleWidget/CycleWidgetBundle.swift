//
//  CycleWidgetBundle.swift
//  CycleWidget
//
//  Created by Haider on 1/3/26.
//

import WidgetKit
import SwiftUI

@main
struct ChecklistWidgetBundle: WidgetBundle {
    var body: some Widget {
        CycleWidget(cardIndex: 0)
        CycleWidget(cardIndex: 1)
        CycleWidget(cardIndex: 2)
        CycleWidget(cardIndex: 3)
        CycleWidget(cardIndex: 4)
    }
}
