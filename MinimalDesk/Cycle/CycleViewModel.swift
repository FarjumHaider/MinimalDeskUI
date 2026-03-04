//
//  CycleViewModel.swift
//  MinimalDesk
//
//  Created by Haider on 20/2/26.
//

import SwiftUICore
import WidgetKit
public class CycleViewModel: ObservableObject {
    private let cycleListKey = "cycle-list"

    @Published var cards: Int = UserDefaults.standard.value(forKey: UserDefaultsKeys.cycleListCount.rawValue) as? Int ?? 0
    private let userdefault = UserDefaults(suiteName: "group.minimaldesk")
    
    @Published var cycleListView: [CycleModel]

    let units = ["hours", "days"]
    
    static private var viewModel: CycleViewModel?
    static var shared: CycleViewModel {
        if viewModel == nil {
            viewModel = CycleViewModel()
        }
        return viewModel!
    }

    private init() {
        cycleListView = []
        (0...20).forEach { _ in
            cycleListView.append(.empty)
        }

        getCycleCache()
    }
    
}

extension CycleViewModel {
    func saveCycleData(for cardIndex: Int) {
        guard let userdefault else {
            log("Did not find userdefault.")
            return
        }
        
        userdefault.set(try? JSONEncoder().encode(cycleListView[cardIndex]), forKey: cycleListKey+"\(cardIndex)")
        
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget4")
    }
    
    func getCycleCache() {
        (0...cards).forEach { cardIndex in
            guard let data = userdefault?.data(forKey: cycleListKey+"\(cardIndex)") else {
                cycleListView[cardIndex] = CycleModel(title: "", selectedDate: Date(), repeatNumber: 1, repeatUnit: "hours", completedCycles: [:])
                //saveCycleData(for: cardIndex)
                return
            }
            
            if let todoList = try? JSONDecoder().decode(CycleModel.self, from: data) {
                cycleListView[cardIndex] = todoList
            }
        }
    }
    
    func deleteCycleCard(cardIndex: Int) {
        if cardIndex >= cards - 1 {
            cycleListView[cardIndex] = .empty
            
        } else {
            for position in (cardIndex..<(cards - 1)) {
                cycleListView[position] = cycleListView[position + 1]
                saveCycleData(for: position)
            }
        }
        
        cards -= 1
        if cards < 0 { cards = 0 }
        UserDefaults.standard.set(cards, forKey: UserDefaultsKeys.cycleListCount.rawValue)
        
        for ind in cards...20 {
            cycleListView[ind] = .empty
            userdefault?.set(nil, forKey: cycleListKey + "\(ind)")
        }
        
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget4")
    }
}

extension CycleViewModel {
    
    func historyOccurIndex(cardIndex: Int, date: Date) -> Int {
        let selectedDate = cycleListView[cardIndex].selectedDate
        let repeateHour = cycleListView[cardIndex].repeatNumber * (cycleListView[cardIndex].repeatUnit == "hours" ? 60 : 1440)
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.minute], from: selectedDate, to: date)
        guard let totalMin = components.minute else { return 0 }
        print("Farjum historyOccurIndex -> totalMin: \(totalMin), repeateHour: \(repeateHour) , date : \(date)")
        return totalMin/repeateHour
    }
    
    func dateHistoryCheck(cardIndex: Int)  {
        var dummydateHistory : [Int: Date] = [:]
        cycleListView[cardIndex].completedCycles.forEach({ _, date in
            let index = historyOccurIndex(cardIndex: cardIndex, date: date)
            print("Farjum dateHistoryCheck index : \(index)")
            dummydateHistory[index] = date
        })
        
        cycleListView[cardIndex].completedCycles = dummydateHistory
    }
    
    func saveMarkDate(cardIndex: Int) {
        let index = historyOccurIndex(cardIndex: cardIndex, date: Date())
        //if cycleListView[cardIndex].completedCycles[index] != ni { return }
        cycleListView[cardIndex].completedCycles[index] = Date()
        saveCycleData(for: cardIndex)
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget4")
    }
    
    func mark(cardIndex: Int) -> Bool {
        let index = historyOccurIndex(cardIndex: cardIndex, date: Date())
        print("Farjum mark index : \(index)")
        if cycleListView[cardIndex].completedCycles[index] != nil { return true}
        else { return false }
        
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget4")
    }
    
    func deleteLastHistoryDate(cardIndex: Int) {
        let index = historyOccurIndex(cardIndex: cardIndex, date: Date())
        guard let lastCycleKey =  cycleListView[cardIndex].completedCycles.keys.max() else { return }
        let lastCycleDate = cycleListView[cardIndex].completedCycles[lastCycleKey]
        
        if index == lastCycleKey {
            cycleListView[cardIndex].completedCycles.removeValue(forKey: lastCycleKey)
        }
        dateHistoryCheck(cardIndex: cardIndex)
        saveCycleData(for: cardIndex)
        
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "CycleWidget4")
    }
}

extension CycleViewModel {
    func test()  {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.timeZone = .current

        let testCases = [
            ("2026-02-05 01:17", "2026-02-07 02:16", 2939),
            ("2026-02-02 02:17", "2026-02-07 22:16", 8559),  // 5 days + 19h 59m = 5*24*60+19*60+59 = 8559
            ("2026-02-01 00:00", "2026-02-01 01:00", 60),
            ("2026-02-01 12:30", "2026-02-01 12:45", 15),
            ("2026-02-01 12:00", "2026-02-02 12:00", 1440),
            ("2026-02-05 01:00", "2026-02-05 04:20", 200),
            ("2026-02-05 10:00", "2026-02-05 09:00", -60)
        ]
        
//        for test in testCases {
//            guard let start = formatter.date(from: test.0),
//                  let end = formatter.date(from: test.1) else {
//                print("Invalid date format for test case: \(test)")
//                continue
//            }
//            
//            let totalMinutes = Int(end.timeIntervalSince(start) / 60)
//            let repeatUnits = totalMinutes / repeatHour
//            print("Start: \(test.0), End: \(test.1) → Minutes: \(totalMinutes), Repeat Units: \(repeatUnits)")
//        }
    }
}
