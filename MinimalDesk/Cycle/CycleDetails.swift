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
        //viewModel.dateHistoryCheck(cardIndex: cardIndex)
    }
    
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                
                VStack(spacing: 20) {
                        Text(viewModel.cycleListView[cardIndex].title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.all, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 14)
                                    .fill(Color("whiteColor"))
                            )
                            .padding(.horizontal)
                        
                        VStack {
                            HStack {
                                Text("Start Time")
                                Spacer()
                                
                                Text("\(viewModel.cycleListView[cardIndex].formattedDate)")
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 15)
                            .padding(.top, 15)
                            
                            Divider()
                                .padding(.leading, 15)
                            
                            HStack {
                                Text("Repeats Every")
                                Spacer()
                                Text("\(viewModel.cycleListView[cardIndex].repeatNumber) \(viewModel.cycleListView[cardIndex].repeatUnit)")
                                    .foregroundColor(.gray)
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 15)
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 14)
                                .fill(Color("whiteColor"))
                        )
                        .padding(.horizontal)
                        
                        
                        VStack {
                            Text("History")
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .padding(.horizontal, 30)
                                .foregroundColor(.gray)

                            ScrollView(showsIndicators: false) {
                                VStack {
                                    ForEach(
                                        Array(
                                            viewModel.cycleListView[cardIndex]
                                                .completedCycles
                                                .sorted(by: { $0.key < $1.key })
                                                .enumerated()
                                        ),
                                        id: \.element.key
                                    ) { index, element in
                                        
                                        let (key, date) = element
                                        
                                        VStack {
                                            HStack {
                                                Text(date.formatted(.dateTime.day().month().year().hour().minute()))
                                                Spacer()
                                            }
                                            .padding(.horizontal, 15)
                                            .padding(.top, index == 0 ? 15 : 0)   // 👈 Only first item gets top padding
                                            
                                            Divider()
                                                .padding(.leading, 15)
                                        }
                                    }
                                    
                                    Button(viewModel.mark(cardIndex: cardIndex) ? "Mark as Undone" : "Mark as Done") {
                                        if viewModel.mark(cardIndex: cardIndex) {
                                            viewModel.deleteLastHistoryDate(cardIndex: cardIndex)
                                        } else {
                                            viewModel.saveMarkDate(cardIndex: cardIndex)
                                        }
                                    }
                                    .frame(maxWidth: .infinity, alignment: .leading)   // 👈 clean solution
                                    .padding(.horizontal, 15)
                                    .padding(.bottom, 15)
                                }
                                .background(
                                    RoundedRectangle(cornerRadius: 14)
                                        .fill(Color("whiteColor"))
                                )
                                .padding(.horizontal)
                            }
                        }
                        
//                        Section {
//
//                            
//                            HStack {
//                                //let mark = viewModel.mark(cardIndex: cardIndex)
//                                Button(viewModel.mark(cardIndex: cardIndex) ? "Maark as Undone" : "Mark as Done") {
//                                    if viewModel.mark(cardIndex: cardIndex) {
//                                        viewModel.deleteLastHistoryDate(cardIndex: cardIndex)
//                                    } else {
//                                        viewModel.saveMarkDate(cardIndex: cardIndex)
//                                    }
//                                }
//                            }
//                            .listRowBackground(Color("whiteColor"))
//                        }
                        
//                        Section{
//                            VStack {
//                                Text("History")
//                                    .listRowBackground(Color.clear)
//                                    .listRowSeparator(.hidden)
//                                    .listRowInsets(EdgeInsets(top: 20, leading: 18, bottom: 5, trailing: 16))
//                                
//                                viewModel.cycleListView[cardIndex].completedCycles.forEach({ key, date in
//                                    Text("\(date)")
//                                })
//                            }
//                            .listRowBackground(Color("whiteColor"))
//                        }
//
//                        
//                        Section {
//                            VStack
//                            let mark = viewModel.mark(cardIndex: cardIndex)
//                            Button(mark ? "Maark as Undone" : "Mark as Done") {
//                                if mark {
//                                    viewModel.deleteLastHistoryDate(cardIndex: cardIndex)
//                                } else {
//                                    viewModel.saveMarkDate(cardIndex: cardIndex)
//                                }
//                            }
//                            .listRowBackground(Color("whiteColor"))
//                        }
//                        .listSectionSpacing(.compact)
                    Spacer()
                }
                
            }
        }
        .onAppear{
            //print("Farjum \(viewModel.cycleListView[cardIndex].selectedDate)")
            viewModel.dateHistoryCheck(cardIndex: cardIndex)
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
