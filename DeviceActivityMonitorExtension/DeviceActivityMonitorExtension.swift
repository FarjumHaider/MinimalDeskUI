//
//  DeviceActivityMonitorExtension.swift
//  DeviceActivityMonitorExtension
//
//  Created by Haider on 18/1/26.
//

import DeviceActivity
import ManagedSettings
import Foundation
import FamilyControls
import Combine
import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings
import UIKit
import SwiftUICore
// Optionally override any of the functions below.
// Make sure that your class name matches the NSExtensionPrincipalClass in your Info.plist.
class DeviceActivityMonitorExtension: DeviceActivityMonitor {
    
    // Main app saves selection
    let userDefaults = UserDefaults(suiteName: "group.wasim.minimaldesk")
    

    
    override func intervalDidStart(for activity: DeviceActivityName) {
        print("🔥 intervalDidStart fired: \(activity.rawValue)")
        
        guard let data = userDefaults?.data(forKey: "ScreenTimeSelection") else { return }
        
        guard let activitySelection = try? PropertyListDecoder().decode(FamilyActivitySelection.self, from: data) else {
            return
        }
        
        // Apply your app restrictions
        let store = ManagedSettingsStore(named: .init("MinimalDesk.AppLocker.Store"))
        store.shield.applications = activitySelection.applicationTokens
        store.shield.applicationCategories = .specific(activitySelection.categoryTokens)
    }
    
    override func intervalDidEnd(for activity: DeviceActivityName) {
        print("🔥 intervalDidEnd fired: \(activity.rawValue)")
        
        let store = ManagedSettingsStore(named: .init("MinimalDesk.AppLocker.Store"))
//        store.shield.applications?.removeAll()
//        store.shield.applicationCategories = .none
        
        store.shield.applications?.removeAll()
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy<Application>.none
    }
    
    override func eventDidReachThreshold(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventDidReachThreshold(event, activity: activity)
        
        // Handle the event reaching its threshold.
    }
    
    override func intervalWillStartWarning(for activity: DeviceActivityName) {
        super.intervalWillStartWarning(for: activity)
        
        // Handle the warning before the interval starts.
    }
    
    override func intervalWillEndWarning(for activity: DeviceActivityName) {
        super.intervalWillEndWarning(for: activity)
        
        // Handle the warning before the interval ends.
    }
    
    override func eventWillReachThresholdWarning(_ event: DeviceActivityEvent.Name, activity: DeviceActivityName) {
        super.eventWillReachThresholdWarning(event, activity: activity)
        
        // Handle the warning before the event reaches its threshold.
    }
}
