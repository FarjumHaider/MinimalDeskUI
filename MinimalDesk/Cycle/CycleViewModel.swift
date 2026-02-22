//
//  CycleViewModel.swift
//  MinimalDesk
//
//  Created by Haider on 20/2/26.
//

import SwiftUICore
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
    }
    
    func getCycleCache() {
        (0...cards).forEach { cardIndex in
            guard let data = userdefault?.data(forKey: cycleListKey+"\(cardIndex)") else {
                cycleListView[cardIndex] = CycleModel(title: "", selectedDate: Date(), selectedTime: Date(), repeatNumber: 1, repeatUnit: "hours")
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
        
//        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget0")
//        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget1")
//        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget2")
//        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget3")
//        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget4")
    }
}

extension CycleViewModel {
    
}
