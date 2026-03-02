//
//  WidgetViewModel.swift
//  MinimalDesk
//
//  Created by Rakib Hasan on 25/9/24.
//

import Foundation
import SwiftUI
import WidgetKit

class WidgetViewModel: ObservableObject {
    let resetConfig: FavAppWidgetConfig = .init(
        fontType: "Chalkduster",
        fontWeight: "regular",
        fontSize: 30,
        fontColor: "#000000",
        backgroundColor: "#FFFFFF",
        alignment: "left",
        spacing: 16,
        maxNumberOfApps: 5,
        caseText: "default"
    )
    
    var alignmentPairfavApp: (HorizontalAlignment, VerticalAlignment) {
        switch favAppWidgetConfig.alignment {
        case "left":
            return (.leading, .center)

        case "right":
            return (.trailing, .center)

        case "hCenter", "vCenter":
            return (.center, .center)

        case "top":
            return (.center, .top)

        case "bottom":
            return (.center, .bottom)
            
        default:
            return (.center, .bottom)
        }
    }
    
    var alignmentPairCheckList: (HorizontalAlignment, VerticalAlignment) {
        switch checkListWidgetConfig.alignment {
        case "left":
            return (.leading, .center)

        case "right":
            return (.trailing, .center)

        case "hCenter", "vCenter":
            return (.center, .center)

        case "top":
            return (.center, .top)

        case "bottom":
            return (.center, .bottom)
            
        default:
            return (.center, .bottom)
        }
    }
    var alignmentPairCycleList: (HorizontalAlignment, VerticalAlignment) {
        switch cycleWidgetConfig.alignment {
        case "left":
            return (.leading, .center)

        case "right":
            return (.trailing, .center)

        case "hCenter", "vCenter":
            return (.center, .center)

        case "top":
            return (.center, .top)

        case "bottom":
            return (.center, .bottom)
            
        default:
            return (.center, .bottom)
        }
    }
    
    static var shared = WidgetViewModel()
    
    private let userdefault = UserDefaults(suiteName: "group.minimaldesk")
    @Published var favAppWidgetConfig: FavAppWidgetConfig
    @Published var checkListWidgetConfig: ChecklistWidgetConfig
    @Published var dateConfig: DateConfig
    @Published var cycleWidgetConfig: CycleWidgetConfig
    
    private init() {
        favAppWidgetConfig = FavAppWidgetConfig.defaultConfig
        dateConfig = DateConfig.defaultConfig
        checkListWidgetConfig = ChecklistWidgetConfig.defaultConfig
        cycleWidgetConfig = CycleWidgetConfig.defaultConfig
        
        let config = userdefault?.value(forKey: "favorite-apps-config") as? Data ?? Data()
        if let widgetConfig = try? JSONDecoder().decode(FavAppWidgetConfig.self, from: config) {
            favAppWidgetConfig = widgetConfig
        }
        
        let config1 = userdefault?.value(forKey: "favorite-date-config") as? Data ?? Data()
        if let widgetConfig1 = try? JSONDecoder().decode(DateConfig.self, from: config1) {
            dateConfig = widgetConfig1
        }
        
        let configChecklist = userdefault?.value(forKey: "todo-list-config") as? Data ?? Data()
        if let configWidgetChecklist = try? JSONDecoder().decode(ChecklistWidgetConfig.self, from: configChecklist) {
            checkListWidgetConfig = configWidgetChecklist
        }
        
        let configCycleList = userdefault?.value(forKey: "cycle-list-config") as? Data ?? Data()
        if let configWidgetCyclelist = try? JSONDecoder().decode(CycleWidgetConfig.self, from: configCycleList) {
            cycleWidgetConfig = configWidgetCyclelist
        }
    }
}

// MARK: - Public APIs
extension WidgetViewModel {
    func fetchAllFonts() -> [String] {
        var allFonts: [String] = []
        UIFont.familyNames.forEach { familyName in
            UIFont.fontNames(forFamilyName: familyName).forEach { fontName in
                print(fontName)
                allFonts.append(fontName)
            }
        }
        
        return allFonts.sorted()
    }
    
    func setNewFavWidgetConfig() {
        userdefault?.setValue(try? JSONEncoder().encode(favAppWidgetConfig), forKey: "favorite-apps-config")
        WidgetCenter.shared.reloadTimelines(ofKind: "FavAppWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "FavAppWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "FavAppWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "FavAppWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "FavAppWidget4")
        WidgetCenter.shared.reloadTimelines(ofKind: "FavAppWidget5")
    }
    
    func setTodoWidgetConfig() {
        userdefault?.setValue(try? JSONEncoder().encode(checkListWidgetConfig), forKey: "todo-list-config")

        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget4")
    }
    func setCycleWidgetConfig() {
        userdefault?.setValue(try? JSONEncoder().encode(cycleWidgetConfig), forKey: "cycle-list-config")

        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget4")
    }
    
    
    func setDateWidgetConfig() {
        userdefault?.setValue(try? JSONEncoder().encode(dateConfig), forKey: "favorite-date-config")
        WidgetCenter.shared.reloadTimelines(ofKind: "MinimalDeskDateWidget")
    }
    
    
    func setTopWidget(theme: String) {
        userdefault?.set(theme, forKey: "current-widget-theme")
        userdefault?.setValue(try? JSONEncoder().encode(dateConfig), forKey: "favorite-date-config")
        
        WidgetCenter.shared.reloadTimelines(ofKind: "MinimalDeskDateWidget")
    }
    
    func getSelectedThemeForTopWidget() -> String {
        userdefault?.string(forKey: "current-widget-theme") ?? ""
    }
}
