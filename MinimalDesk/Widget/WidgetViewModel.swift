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
        maxNumberOfApps: 5
    )
    
    // MARK: - Alignment Pair
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
    
    private init() {
        favAppWidgetConfig = FavAppWidgetConfig.defaultConfig
        
        let config = userdefault?.value(forKey: "favorite-apps-config") as? Data ?? Data()
        if let widgetConfig = try? JSONDecoder().decode(FavAppWidgetConfig.self, from: config) {
            favAppWidgetConfig = widgetConfig
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
    
    func setTopWidget(theme: String) {
        userdefault?.set(theme, forKey: "current-widget-theme")
        WidgetCenter.shared.reloadTimelines(ofKind: "MinimalDeskDateWidget")
    }
    
    func getSelectedThemeForTopWidget() -> String {
        userdefault?.string(forKey: "current-widget-theme") ?? ""
    }
}
