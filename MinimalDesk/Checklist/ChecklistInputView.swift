//
//  ChecklistInputView.swift
//  MinimalDesk
//
//  Created by Haider on 29/1/26.
//

import SwiftUI
import SwiftUI
import Siren

struct ChecklistInputView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showNewItemField = false
    @State private var showActions = false
    @State private var todoName = ""
    @State var showToast =  false
    
    @ObservedObject private var viewModel: ChecklistViewModel
    private var cardIndex: Int = 0
    
    @State private var selectedItems: Set<TodoItem> = []
    @State private var selectedIndex: Int = 0
    
    init(viewModel: ChecklistViewModel, cardIndex: Int = 0) {
        self.viewModel = viewModel
        self.cardIndex = cardIndex
        //initialFetch()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                VStack{
                    VStack {
                        
                        List {
                            ForEach(viewModel.todoListView[cardIndex].indices, id: \.self) { index in
                                HStack {
                                    TextField(
                                        "Todo",
                                        text: $viewModel.todoListView[cardIndex][index].title
                                    )
                                    .strikethrough(viewModel.todoListView[cardIndex][index].isCompleted)
                                    
                                    
                                    Button {
                                        selectedIndex = index
                                        showActions = true
                                    } label: {
                                        Image(systemName: "ellipsis")
                                            .foregroundColor(.black)
                                    }
                                }
                                .listRowBackground(Color.gray)
                                //.padding(.vertical, 4)
                            }
                            
                            if showNewItemField {
                                TextField("Add new item", text: $todoName, onCommit: {
                                    addNewItem()
                                })
                                .listRowBackground(Color.gray)
                                //.padding()
                            }
                            
                            Button {
                                checkCount()
                            } label: {
                                HStack {
                                    Image(systemName: "plus.circle.fill")
                                    Text("Add new item")
                                }
                            }
                            .listRowBackground(Color.gray)
                        }
                        .listRowInsets(EdgeInsets())
                        .listStyle(.insetGrouped)
                        .scrollContentBackground(.hidden)
                        .background(Color.clear)
                        .listRowSeparator(.visible)
                        //.frame(width: geo.size.width * 0.9)
                    }
                    
                    Spacer()
                }
                
                if showToast {
                    ToastView(message: "Max 6 list can be added to a todo list")
                }
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                HStack {
                    Text("Checklist #2")
                        .font(.headline)
                    Image(systemName: "chevron.down")
                        .font(.caption)
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Done") {
                    viewModel.saveTodoList(for: cardIndex)
                    if cardIndex == viewModel.cards {
                        viewModel.cards += 1
                        UserDefaults.standard.set(viewModel.cards , forKey: UserDefaultsKeys.todoListCount.rawValue)
                    }
                    dismiss()
                    
                }
            }
        }
        .confirmationDialog("", isPresented: $showActions, titleVisibility: .hidden) {
            //guard let selectedIndex else { return }
            
            //viewModel.todoListView[cardIndex][selectedIndex].isCompleted ? "Mark as Undone" :
            
            Button("Mark as Done") {
                toggleCompletion()
            }

            Button("Remove", role: .destructive) {
                removeItem()
            }
        }
        .onAppear {
            //initialFetch()
        }
//        .sheet(isPresented: $isPresented) {
//            CustomWidget()
//        }
    }
    

}

//extension ChecklistInputView {
//    func initialFetch() {
//        viewModel.todoListView[cardIndex].forEach { todoItem in
//            selectedItems.insert(todoItem)
//        }
//    }
//}
//
//
extension ChecklistInputView {
    // MARK: - Add new item
    private func addNewItem() {
        let trimmed = todoName.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            todoName = ""
            showNewItemField = false
            return
        }
        todoName = ""
        //viewModel.todoListView[cardIndex].append(trimmed)
        viewModel.todoListView[cardIndex].append(TodoItem(title: trimmed, isCompleted: false))
        showNewItemField = false
    }
//    
//    
//    // MARK: - unmark / mark item
    private func toggleCompletion() {
       // guard let selectedIndex else { return }
        viewModel.todoListView[cardIndex][selectedIndex].isCompleted.toggle()
    }
//    
//    
//    // MARK: - Delete item
    private func removeItem() {
        //guard let selectedIndex else { return }
        viewModel.todoListView[cardIndex].remove(at: selectedIndex)
    }
    
    private func checkCount() {
        if viewModel.todoListView[cardIndex].count < 6 {
            todoName = ""
            showNewItemField = true
        } else {
            showToast = true
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                showToast = false
            }
        }
    }
}
