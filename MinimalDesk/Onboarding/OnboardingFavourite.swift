//
//  OnboardingFavourite.swift
//  MinimalDesk
//
//  Created by Haider on 28/12/25.
//

import SwiftUI

struct OnboardingFavourite: View {
    
    @ObservedObject var viewModel = OnboardingViewModel.shared
    @State private var searchText = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    
    var filteredApps: [String] {
        if searchText.isEmpty {
            return FirebaseDataViewModel.shared.onlyAppName
        } else {
            return FirebaseDataViewModel.shared.onlyAppName.filter{
                $0.localizedStandardContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            //Color.black.edgesIgnoringSafeArea(.all)
            //Life without the distraction
            
            ZStack {

                
                //VStack {
                    
                ZStack(alignment: .top) {
                    // main content

                    if showToast {
                        Text(toastMessage)
                            .foregroundColor(Color("textColor"))
                            .font(.system(size: 17, weight: .medium))
                            .frame(maxWidth: UIScreen.main.bounds.width * 0.8)
                            .frame(height: 50)
                            .background(Color("whiteColor"))
                            .cornerRadius(15)
                            .padding(.top, 60) // respects status bar area
                            .transition(.move(edge: .top).combined(with: .opacity))
                            .zIndex(1)
                    }
                }

                    
                    ZStack {
                        
                        
                        Image("favouriteApps")
                            .resizable()
                            .scaledToFit()
                            .frame(width: screenWidth * 0.75, height: screenHeight * 0.65)
                        //.padding(.vertical, 40)
                        //                        .overlay(alignment: .bottom) {
                        //                            LinearGradient(
                        //                                colors:
                        //                                    [
                        //                                        .clear,
                        //                                        Color("backgroundColor").opacity(0.4),
                        //                                        Color("backgroundColor").opacity(0.8)
                        //                                    ],
                        //                                startPoint: .top,
                        //                                endPoint: .bottom
                        //                            )
                        //                            .frame(height: 180)
                        //                        }
                        
                        VStack {
                            searchBox()
                            
                            
                            List {
                                ForEach(filteredApps, id: \.self) { appName in
                                    HStack {
                                        Text(appName)
                                            .foregroundColor(.white)
                                            .font(.headline)
                                            .fontWeight(.light)
                                            .padding(.vertical, 6)
                                        
                                        Spacer()
                                        
                                        if viewModel.selectedAppName.contains(appName) {
                                            Image("right")
                                                .renderingMode(.template)
                                                .resizable()
                                                .frame(width: 20, height: 20)
                                                .padding(.trailing, 16)
                                                .foregroundColor(Color.white)
                                        }
                                        
                                        
                                        //                                    Button {
                                        //                                        toggleSelection(for: appName)
                                        //                                    } label: {
                                        //                                        Image(systemName: viewModel.selectedAppName.contains(appName) ? "checkmark" : "plus")
                                        //                                            .foregroundColor(viewModel.selectedAppName.contains(appName) ? .green : .white)
                                        //                                            .font(.title2)
                                        //                                    }
                                        //                                    .buttonStyle(PlainButtonStyle())
                                        //                                    .padding(.vertical, 6)
                                    }
                                    .listRowBackground(Color.black)
                                    .onTapGesture {
                                        toggleSelection(for: appName)
                                    }
                                }
                            }
                            .listStyle(PlainListStyle())
                            .scrollContentBackground(.hidden)
                            .padding(.horizontal)
                            //                        .overlay(alignment: .bottom) {
                            //                            LinearGradient(
                            //                                colors:
                            //                                    [
                            //                                        .clear,
                            //                                        Color("backgroundColor").opacity(0.4),
                            //                                        Color("backgroundColor").opacity(0.8)
                            //                                    ],
                            //                                startPoint: .top,
                            //                                endPoint: .bottom
                            //                            )
                            //                            .frame(height: 50)
                            //                        }
                            //                    List {
                            //                        ForEach(filteredApps, id: \.self) { item in
                            //                            Text(item)
                            //                                .foregroundColor(.white)
                            //                                .font(.headline)
                            //                                .fontWeight(.light)
                            //                                .padding(.vertical, 6)
                            //                                .background(Color.black)
                            //                        }
                            //                    }
                            //                    .listStyle(PlainListStyle())
                            //                    .scrollContentBackground(.hidden)
                            //                    .background(Color.black)
                            //
                            //                    .overlay(
                            //                        RoundedRectangle(cornerRadius: 16)
                            //                            .stroke(Color.red, lineWidth: 4)
                            //                    )
                        }
                        //.background(Color.black)
                        .frame(width: screenWidth * 0.68, height: screenHeight * 0.38)
                        .offset(y: 25)
                        
                    }
                    .overlay(alignment: .bottom) {
                        LinearGradient(
                            colors:
                                [
                                    .clear,
                                    Color("backgroundColor").opacity(0.4),
                                    Color("backgroundColor").opacity(0.8)
                                ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: 180)
                    }
                //}

                
                Text("Add Favourite Apps")
                    //.multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .medium))
                    .offset(y: 250)
                
                Text("Pick up to 6 frequently used apps for")
                    //.multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#646464"))
                    .font(.system(size: 16))
                    .offset(y: 290)
                Text("quick access. Keep your home screen")
                    //.multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#646464"))
                    .font(.system(size: 16))
                    .offset(y: 315)
                
                Text("tidy and distraction-free")
                    //.multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#646464"))
                    .font(.system(size: 16))
                    .offset(y: 340)
                    .padding()
                    

            }
        }
    }
    
    private func searchBox() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search...")
                        .foregroundColor(.white.opacity(0.6))
                        .fontWeight(.regular)
                }
                .foregroundColor(.white)
                .padding(10)
        }
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
        .padding(.horizontal)
    }
    
    private func toggleSelection(for appName: String) {
        if let index = viewModel.selectedAppName.firstIndex(of: appName) {
            viewModel.selectedAppName.remove(at: index)
        } else if viewModel.selectedAppName.count < 6 {
            viewModel.selectedAppName.append(appName)
        } else {
            showToastMessage("You can select up to 6 apps only.")
        }
    }
    
    private func showToastMessage(_ message: String) {
        toastMessage = message
        withAnimation {
            showToast = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            withAnimation {
                showToast = false
            }
        }
    }
}

#Preview {
    OnboardingFavourite()
}
