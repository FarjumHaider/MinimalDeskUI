//
//  ChecklistViewModel.swift
//  MinimalDesk
//
//  Created by Haider on 27/1/26.
//

import Foundation
import Combine
import Firebase
import WidgetKit
import SwiftUI
import Network

public class ChecklistViewModel: ObservableObject {
    private let todoListKey = "todo-list"
    private let todoListCountKey = "todo-list-count"

    @Published var cards: Int = UserDefaults.standard.value(forKey: UserDefaultsKeys.todoListCount.rawValue) as? Int ?? 0
    private let userdefault = UserDefaults(suiteName: "group.minimaldesk")
    
    @Published var todoListView: [[TodoItem]]

    static private var viewModel: ChecklistViewModel?
    static var shared: ChecklistViewModel {
        if viewModel == nil {
            viewModel = ChecklistViewModel()
        }
        return viewModel!
    }
    
    private init() {
        todoListView = []
        (0...20).forEach { _ in
            todoListView.append([])
        }
        getTodoCache()
    }
}

extension ChecklistViewModel {
//    func getTodoCache() {
//        
//        (0...cards).forEach { cardIndex in
//            todoListView[cardIndex] = userdefault?.value(forKey: todoListKey+"\(cardIndex)") as? [TodoItem] ?? []
//        }
//    }
//    
//    func saveTodoList(in todoInputList: [TodoItem], for cardIndex: Int) {
//        guard let userdefault else {
//            log("Did not find userdefault.")
//            return
//        }
//        print("Farjum:  \(todoInputList)")
//        todoListView[cardIndex] = todoInputList
//       // userdefault.set(todoListView[cardIndex], forKey: todoListKey+"\(cardIndex)")
//    }
    
    func getTodoCache() {
        (0...cards).forEach { cardIndex in
            guard let data = userdefault?.data(forKey: todoListKey+"\(cardIndex)") else {
                todoListView[cardIndex] = []
                return
            }
            
            if let todoList = try? JSONDecoder().decode([TodoItem].self, from: data) {
                todoListView[cardIndex] = todoList
            }
//            do {
//                todoListView[cardIndex] = try JSONDecoder().decode([TodoItem].self, from: data)
//            } catch {
//                print("Failed to decode todo list for card \(cardIndex):", error)
//                todoListView[cardIndex] = []
//            }
        }
    }
    
    func saveTodoList(for cardIndex: Int) {
        guard let userdefault else {
            log("Did not find userdefault.")
            return
        }
        
        if todoListView[cardIndex].isEmpty {
            setTodoDeleteCard(cardIndex: cardIndex)
        } else {
//            do {
//                let data = try JSONEncoder().encode(todoListView[cardIndex])
//                //todoListView[cardIndex] = todoInputList
//                userdefault.set(data, forKey: todoListKey+"\(cardIndex)")
//            } catch {
//                print("Failed to encode todo list:", error)
//            }
            userdefault.set(try? JSONEncoder().encode(todoListView[cardIndex]), forKey: todoListKey+"\(cardIndex)")
        }
        
        
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget4")
    }
    
    func deleteTodoList() {
        
    }
    
    func toggleCompletion(index: Int, itemIndex: Int) {
        //guard let selectedIndex else { return }
        todoListView[index][itemIndex].isCompleted.toggle()
        saveTodoList(for: index)
        
    }
    
    func setTodoDeleteCard(cardIndex: Int) {
        if cardIndex >= cards - 1 {
            todoListView[cardIndex] = []
        } else {
            for position in (cardIndex..<(cards - 1)) {
                todoListView[position] = todoListView[position + 1]
                saveTodoList(for: position)
            }
        }
        
        cards -= 1
        if cards < 0 { cards = 0 }
        UserDefaults.standard.set(cards, forKey: UserDefaultsKeys.todoListCount.rawValue)
        
        for ind in cards...20 {
            todoListView[ind] = []
            userdefault?.set(nil, forKey: todoListKey + "\(ind)")
        }
        
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget0")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget1")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget2")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget3")
        WidgetCenter.shared.reloadTimelines(ofKind: "ChecklistWidget4")
    }
}
