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
    @State var showDeleteCard =  false
    
    @ObservedObject private var viewModel: ChecklistViewModel
    private var cardIndex: Int = 0
    
    //@State private var selectedItems: Set<TodoItem> = []
    @State private var selectedIndex: Int = 0
    
    init(viewModel: ChecklistViewModel, cardIndex: Int) {
        self.viewModel = viewModel
        self.cardIndex = cardIndex
        //initialFetch()
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                VStack{
                    VStack {
                        
                        List {
                            Section{
                                ForEach(viewModel.todoListView[cardIndex].indices, id: \.self) { index in
                                    HStack {
                                        TextField (
                                            "Todo",
                                            text: $viewModel.todoListView[cardIndex][index].title
                                        )
                                        .strikethrough(viewModel.todoListView[cardIndex][index].isCompleted)
                                        .foregroundColor(Color("textColor"))
                                        .opacity(viewModel.todoListView[cardIndex][index].isCompleted ? 0.4 : 1)
                                        
                                        Button {
                                            selectedIndex = index
                                            showActions = true
                                        } label: {
                                            Image(systemName: "ellipsis")
                                                .foregroundColor(Color("textColor"))
                                        }
                                    }
                                    .listRowBackground(Color("whiteColor"))
                                    //.padding(.vertical, 4)
                                }
                                
                                if showNewItemField {
                                    TextField("Add new item", text: $todoName, onCommit: {
                                        addNewItem()
                                    })
                                    .listRowBackground(Color("whiteColor"))
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
                                .listRowBackground(Color("whiteColor"))
                            }
                            
                            Section {
                                Button {
                                    showDeleteCard = true
                                } label: {
                                    HStack {
                                        //Image(systemName: "plus.circle.fill")
                                        Text("Delete Completed Items")
                                            .foregroundColor(Color.red)
                                    }
                                }
                                .listRowBackground(Color("whiteColor"))
                            }
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
        .overlay(
            Group {
                if showDeleteCard {
                    ActionCardToast(
                        title: "Delete Comppleted Items",
                        subTitle: "Are you sure you want to delete all completed items? this action can't be undone",
                        onCancel: {
                            showDeleteCard = false
                        },
                        onDelete: {
                            removeAllItem()
                            showDeleteCard = false
                        }
                    )
                }
            }
        )
        .animation(.spring(), value: showDeleteCard)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
//                HStack {
//                    Text("Checklist #2")
//                        .font(.headline)
//                    Image(systemName: "chevron.down")
//                        .font(.caption)
//                }
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.saveTodoList(for: cardIndex)
                    if cardIndex == viewModel.cards {
                        viewModel.cards += 1
                        UserDefaults.standard.set(viewModel.cards , forKey: UserDefaultsKeys.todoListCount.rawValue)
                    }
                    dismiss()
                    
                }
                .foregroundColor(.blue)
            }
        }
        .confirmationDialog("", isPresented: $showActions, titleVisibility: .hidden) {
            if !viewModel.todoListView[cardIndex].isEmpty {
                Button(viewModel.todoListView[cardIndex][selectedIndex].isCompleted ? "Mark as Undone" : "Mark as Done") {
                    toggleCompletion()
                }

                Button("Remove", role: .destructive) {
                    removeItem()
                }
            }

        }
    }
    

}

extension ChecklistInputView {
    // Add new item
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

    // unmark / mark item
    private func toggleCompletion() {
       // guard let selectedIndex else { return }
        viewModel.todoListView[cardIndex][selectedIndex].isCompleted.toggle()
    }

    // Delete item
    private func removeItem() {
        //guard let selectedIndex else { return }
        viewModel.todoListView[cardIndex].remove(at: selectedIndex)
    }
    
    private func removeAllItem() {
        //guard let selectedIndex else { return }
        //viewModel.todoListView[cardIndex] = []
        viewModel.todoListView[cardIndex].removeAll()
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
