//
//  AppLockerViewModel.swift
//  MinimalDesk
//
//  Created by Rakib Hasan on 20/10/24.
//

import Combine
import DeviceActivity
import FamilyControls
import Foundation
import ManagedSettings
import UIKit
import SwiftUICore

class AppLockerViewModel: ObservableObject {
    private let activitySelectionKey = "ScreenTimeSelection"
    private let appLockStatusKey = "AppLockStatus"
    private let startTimeKey = "AppStartTime"
    private let endTimeKey = "AppEndTime"
    
    let userDefaults = UserDefaults(suiteName: "group.wasim.minimaldesk")
    var cancellable: AnyCancellable?
    
    @Published var activitySelection = FamilyActivitySelection()
    @Published var selectedTokens = [SelectionType]()
    
    var startTime = Date()
    var endTime = Date()
    
    var appLockStatus = false
    
    static let shared = AppLockerViewModel()
    
    private init() {
        loadSavedSelectionAndAppLockStatus()
        
//        cancellable = $activitySelection.sink { [weak self] _ in
//            self?.saveSelection()
//        }
    }
    
//    override func intervalDidStart(for activity: DeviceActivityName) {
//        toggleAppRestriction(lock: true)
//    }
    
//    open override func intervalDidEnd(for activity: DeviceActivityName) {
//        toggleAppRestriction(lock: false)
//    }
    
//    override func intervalDidStart(for activity: DeviceActivityName) {
//        //super.intervalDidStart(for: activity)
//        print("🔥 interval started")
//        if activity == DeviceActivityName("dailyLock") {
//            toggleAppRestriction(lock: true)
//        }
//    }
//    
//    override func intervalDidEnd(for activity: DeviceActivityName) {
//        //super.intervalDidEnd(for: activity)
//        print("🔥 interval end")
//        if activity == DeviceActivityName("dailyLock") {
//            // Remove restrictions when the interval ends
//            toggleAppRestriction(lock: false)
//        }
//    }
    
    // MARK: - Public APIs
    func requestAuthorization() {
        Task {
            do {
                try await AuthorizationCenter.shared.requestAuthorization(for: .individual)
            }
            catch {
                log("Authorization failed.")
            }
        }
    }
    
    func makeSchedule(start: Date, end: Date) -> DeviceActivitySchedule {
//        let calendar = Calendar.current
//        
//        print("Strar time \(start), End Time \(end)")
//        let startComponents = calendar.dateComponents([.hour, .minute], from: start)
//        let endComponents = calendar.dateComponents([.hour, .minute], from: end)
//
        
        //let center = DeviceActivityCenter()
        //let scheduleName = DeviceActivityName("dailyLock")

        // Define the time components for the lock (e.g., start at 10 PM, end at 7 AM)
        var intervalStart = DateComponents()
        intervalStart.hour = 0 //22 // 10 PM
        intervalStart.minute = 15
        var intervalEnd = DateComponents()
        intervalEnd.hour = 4  // 7 // 7 AM
        intervalEnd.minute = 30

        
        
        return DeviceActivitySchedule(
            intervalStart: intervalStart,
            intervalEnd: intervalEnd,
            repeats: true // daily
        )
    }
    
    
    func saveSelection() {
        createSelectedTokens()
        userDefaults?.set(try? PropertyListEncoder().encode(activitySelection), forKey: activitySelectionKey)
        
        userDefaults?.set(startTime, forKey: startTimeKey)
        userDefaults?.set(endTime, forKey: endTimeKey)
        
        stopMonitoring()
//        let schedule = makeSchedule(start: startTime, end: endTime)
//
//        print("schedule \(schedule)")
//        
        let center = DeviceActivityCenter()
        let scheduleName = DeviceActivityName("dailyLock")
        
        let now = Date()
        let fiveMinutesLater = Date(timeInterval: 300, since: now)
        
        let calendar = Calendar.current
        let startComponents = calendar.dateComponents([.hour, .minute], from: now)
        let endComponents = calendar.dateComponents([.hour, .minute], from: fiveMinutesLater)
        
        let schedule = DeviceActivitySchedule(
            intervalStart: startComponents,
            intervalEnd: endComponents,
            repeats: false  // ← Don't repeat, just test once
        )
        
        do {
            try center.startMonitoring(
                scheduleName,
                during: schedule
            )
            print("Monitoring started")
        } catch {
            print("Failed to start monitoring: \(error)")
        }
        
    }
    
    func stopMonitoring() {
        let center = DeviceActivityCenter()
        do {
            try center.stopMonitoring([DeviceActivityName("dailyLock")])
            print("Monitoring stopped")
        } catch {
            print("Failed to stop monitoring: \(error)")
        }
    }
    
    func toggleAppRestriction(lock: Bool) {
        let store = ManagedSettingsStore(named: .init("MinimalDesk.AppLocker.Store"))
        
        store.shield.applications?.removeAll()
        store.shield.applicationCategories = ShieldSettings.ActivityCategoryPolicy<Application>.none
        
        if lock {
            store.shield.applications = activitySelection.applicationTokens
            store.shield.applicationCategories = .specific(activitySelection.categoryTokens)
        }
        
        appLockStatus = lock
        userDefaults?.set(lock, forKey: appLockStatusKey)
    }
}

// MARK: - Private Helper Methods
private extension AppLockerViewModel {
    func loadSavedSelectionAndAppLockStatus() {
        guard let data = userDefaults?.data(forKey: activitySelectionKey) else { return }
        
        guard let activitySelection = try? PropertyListDecoder().decode(FamilyActivitySelection.self, from: data) else {
            return
        }
        
        self.activitySelection = activitySelection
        createSelectedTokens()
        
        guard let appLockStatus = userDefaults?.value(forKey: appLockStatusKey) as? Bool else { return }
        self.appLockStatus = appLockStatus
        
        
        guard let startTime = userDefaults?.value(forKey: startTimeKey) as? Date else { return }
        self.startTime = startTime
        
        guard let endTime = userDefaults?.value(forKey: endTimeKey) as? Date else { return }
        self.endTime = endTime
        
    }
    
    func createSelectedTokens() {
        selectedTokens = []
        activitySelection.applicationTokens.forEach { selectedTokens.append(.application($0)) }
        activitySelection.categoryTokens.forEach { selectedTokens.append(.category($0)) }
    }
}

extension AppLockerViewModel {
    enum SelectionType: Hashable {
        case application(ApplicationToken)
        case category(ActivityCategoryToken)
    }
}

//extension AppLockerViewModel: DeviceActivityMonitor {
////    override func intervalDidStart(for activity: DeviceActivityName) {
////        //applyShield(lock: true)
////    }
////
////    override func intervalDidEnd(for activity: DeviceActivityName) {
////        //applyShield(lock: false)
////    }
//}


// test purpose
extension AppLockerViewModel {
    func testDeviceActivity() {
//        let center = DeviceActivityCenter.init()
//        
//        let activity = DeviceActivityName("testActivity")
//
//        let schedule = DeviceActivitySchedule(
//            intervalStart: DateComponents(hour: 0, minute: 0),
//            intervalEnd: DateComponents(hour: 23, minute: 59),
//            repeats: false
//        )
//
//        do {
//            try center.startMonitoring(activity, during: schedule)
//            print("DeviceActivity seems ENABLED (startMonitoring worked)")
//        } catch {
//            print("DeviceActivity is NOT enabled or entitlement missing: \(error)")
//        }
    }
}


