//
//  CycleEdit.swift
//  MinimalDesk
//
//  Created by Haider on 18/2/26.
//

import SwiftUI
import SwiftUI
import Siren

struct CycleEdit: View {
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject private var viewModel: CycleViewModel
    private var cardIndex: Int = 0
    @State var showDeleteCard =  false
    private var closeEditSheet: () -> Void
    
    init(viewModel: CycleViewModel, cardIndex: Int, closeEditSheet: @escaping () -> Void) {
        self.viewModel = viewModel
        self.cardIndex = cardIndex
        self.closeEditSheet = closeEditSheet
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                    TextField("What's the task?", text: $viewModel.cycleListView[cardIndex].title)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color("whiteColor"))
                        )
                        .padding(.horizontal)
                    
                    VStack {
                        HStack {
                            Text("Start Time")
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            HStack(spacing: 8) {
                                DatePicker(
                                    "",
                                    selection: $viewModel.cycleListView[cardIndex].selectedDate,
                                    displayedComponents: [.date, .hourAndMinute]
                                )
                                .datePickerStyle(.compact)
                                .labelsHidden()

                            }
                            .fixedSize()
                        }
                        .padding(.all, 15)
                        
                        Divider()
                            .padding(.leading, 15)
                        
                        HStack {
                            Text("Repeats Every")
                                .font(.system(size: 16))
                            
                            Spacer()
                            
                            HStack {
                                Text("\(viewModel.cycleListView[cardIndex].repeatNumber) \(viewModel.cycleListView[cardIndex].repeatUnit)")
                                    .foregroundColor(.gray)
                                
                                Image(systemName: "chevron.down")
                                    .font(.system(size: 14, weight: .semibold))
                                    .foregroundColor(.gray)
                            }
                        }
                        .padding(.all, 15)
                        
                        Divider()
                            .padding(.leading, 15)
                        
                        HStack(spacing: 0) {
                            
                            // Number Picker (1–100)
                            Picker("", selection: $viewModel.cycleListView[cardIndex].repeatNumber) {
                                ForEach(1...100, id: \.self) { number in
                                    Text("\(number)")
                                        .tag(number)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(maxWidth: .infinity)
                            
                            // Unit Picker
                            Picker("", selection: $viewModel.cycleListView[cardIndex].repeatUnit) {
                                ForEach(viewModel.units, id: \.self) { unit in
                                    Text(unit)
                                        .tag(unit)
                                }
                            }
                            .pickerStyle(.wheel)
                            .frame(maxWidth: .infinity)
                        }
                        .frame(height: 200)
                        .clipped()
                        
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 14)
                            .fill(Color("whiteColor"))
                    )
                    .padding(.horizontal)
                    
                    // Delete Button
                    Button(role: .destructive) {
                        showDeleteCard = true
                    } label: {
                        Text("Delete Cycle")
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color("whiteColor"))
                            )
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                }

            }
        }
        .onAppear{
            viewModel.dateHistoryCheck(cardIndex: cardIndex)
        }
        .overlay(
            Group {
                if showDeleteCard {
                    ActionCardToast(
                        title: "Are You Sure",
                        subTitle: "This will permanetly remove the cycle and it's logs. This action can't be undone",
                        onCancel: {
                            showDeleteCard = false
                        },
                        onDelete: {
                            viewModel.deleteCycleCard(cardIndex: cardIndex)
                            showDeleteCard = false
                            closeEditSheet()
                        }
                    )
                }
            }
        )
        .animation(.spring(), value: showDeleteCard)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.blue)
                }
                
            }
            
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Save") {
                    viewModel.saveCycleData(for: cardIndex)
                    if cardIndex == viewModel.cards {
                        viewModel.cards += 1
                        UserDefaults.standard.set(viewModel.cards , forKey: UserDefaultsKeys.cycleListCount.rawValue)
                    }
                    dismiss()
                    
                }
                .foregroundColor(.blue)
            }
        }

    }
}
