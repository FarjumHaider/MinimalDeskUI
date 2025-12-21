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
    
    var alignmentPair: (HorizontalAlignment, VerticalAlignment) {
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
    
    static var shared = WidgetViewModel()
    
    private let userdefault = UserDefaults(suiteName: "group.minimaldesk")
    @Published var favAppWidgetConfig: FavAppWidgetConfig
    
    @Published var dateConfig: DateConfig
    
    private init() {
        favAppWidgetConfig = FavAppWidgetConfig.defaultConfig
        
        dateConfig = DateConfig.defaultConfig
        
        let config = userdefault?.value(forKey: "favorite-apps-config") as? Data ?? Data()
        if let widgetConfig = try? JSONDecoder().decode(FavAppWidgetConfig.self, from: config) {
            favAppWidgetConfig = widgetConfig
        }
        
        let config1 = userdefault?.value(forKey: "favorite-date-config") as? Data ?? Data()
        if let widgetConfig1 = try? JSONDecoder().decode(DateConfig.self, from: config1) {
            dateConfig = widgetConfig1
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
