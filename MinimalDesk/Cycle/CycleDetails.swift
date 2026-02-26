//
//  CycleDetails.swift
//  MinimalDesk
//
//  Created by Haider on 18/2/26.
//

import SwiftUI
import SwiftUI
import Siren

struct CycleDetails: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var showCycleEdit = false
    
    @ObservedObject private var viewModel: CycleViewModel
    private var cardIndex: Int = 0
    private var closeDetailsSheet: () -> Void

    init(viewModel: CycleViewModel, cardIndex: Int, closeDetailsSheet: @escaping () -> Void) {
        self.viewModel = viewModel
        self.cardIndex = cardIndex
        self.closeDetailsSheet = closeDetailsSheet
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack {
                    List {
                        Section{
                            Text(viewModel.cycleListView[cardIndex].title)
                                .listRowBackground(Color("whiteColor"))
                        }
                        
                        Section {
                            HStack {
                                Text("Start Time")
                                Spacer()
                                
                                Text("\(viewModel.cycleListView[cardIndex].formattedDate)")
                                    .multilineTextAlignment(.leading)
                            }
                            .listRowBackground(Color("whiteColor"))
                            
                            HStack {
                                Text("Repeats Every")
                                Spacer()
                                Text("\(viewModel.cycleListView[cardIndex].repeatNumber) \(viewModel.cycleListView[cardIndex].repeatUnit)")
                            }
                            .listRowBackground(Color("whiteColor"))
                        }
                        
                        Text("History")
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 20, leading: 18, bottom: 5, trailing: 16))
                        
                        Section {
                            Text("mark")
                                .listRowBackground(Color("whiteColor"))
//                            Text(viewModel.cycleListView[cardIndex].mark ? "Mark as Do" : "Mark as Undone")
//                                .listRowBackground(Color("whiteColor"))
                        }
                        .listSectionSpacing(.compact)
                    }
                    .listRowInsets(EdgeInsets())
                    .listStyle(.insetGrouped)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                    .listRowSeparator(.visible)
                }
            }
        }
        .onAppear{
            print("Farjum \(viewModel.cycleListView[cardIndex].selectedDate)")
        }
        .sheet(isPresented: $showCycleEdit) {
            NavigationStack {
                CycleEdit(viewModel: viewModel, cardIndex: cardIndex, closeEditSheet: {
                    closeDetailsSheet()
                    dismiss()
                })
            }
        }
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
                Button("Edit") {
                    showCycleEdit = true
                }
                .foregroundColor(.blue)
            }
        }
    }
    

}
