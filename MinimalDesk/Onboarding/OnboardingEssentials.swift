////////
////////  OnboardingEssentials.swift
////////  MinimalDesk
////////
////////  Created by Ajijul Hakim Riad on 8/12/24.
////////
//////
//////import SwiftUI
//////
//////struct OnboardingEssentials: View {
//////    @ObservedObject var viewModel = OnboardingViewModel.shared
//////    @State private var searchText = ""
//////    
//////    var filteredApps: [String] {
//////        if searchText.isEmpty {
//////            return FirebaseDataViewModel.shared.onlyAppName
//////        } else {
//////            return FirebaseDataViewModel.shared.onlyAppName.filter { $0.localizedCaseInsensitiveContains(searchText) }
//////        }
//////    }
//////    
//////    var body: some View {
//////        ZStack {
//////            Color.black.edgesIgnoringSafeArea(.all)
//////            
//////            VStack {
//////                Text("Pick Essential Apps")
//////                    .foregroundStyle(.white)
//////                    .font(.largeTitle)
//////                    .fontWeight(.semibold)
//////                Text("Let's start with these apps. You can")
//////                    .foregroundStyle(.white)
//////                    .font(.headline)
//////                    .fontWeight(.regular)
//////                Text("change them later")
//////                    .foregroundStyle(.white)
//////                    .font(.headline)
//////                    .fontWeight(.regular)
//////                
//////                searchBox()
//////                
//////                List(filteredApps, id: \.self) { appName in
//////                    HStack {
//////                        Text(appName)
//////                            .foregroundStyle(.white)
//////                            .font(.headline)
//////                            .fontWeight(.light)
//////                            .padding()
//////                        Spacer()
//////                        Button(action: {
//////                            toggleSelection(for: appName)
//////                        }) {
//////                            Image(systemName: viewModel.selectedAppName.contains(appName) ? "checkmark" : "plus")
//////                                .foregroundColor(viewModel.selectedAppName.contains(appName) ? .green : .white)
//////                                .font(.title2)
//////                        }
//////                        .padding()
//////                    }
//////                    .listRowBackground(Color.gray.opacity(0.2))
//////                    .background(
//////                        RoundedRectangle(cornerRadius: 0)
//////                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
//////                    )
//////                    .listRowInsets(EdgeInsets())
//////                }
//////                .scrollContentBackground(.hidden)
//////            }
//////        }
//////    }
//////    
//////    private func toggleSelection(for appName: String) {
//////        if let index = viewModel.selectedAppName.firstIndex(of: appName) {
//////            viewModel.selectedAppName.remove(at: index)
//////        } else if viewModel.selectedAppName.count < 6 {
//////            viewModel.selectedAppName.append(appName)
//////        }
//////    }
//////    
//////    private func searchBox() -> some View {
//////        HStack {
//////            Image(systemName: "magnifyingglass")
//////                .foregroundColor(.gray)
//////                .padding(.leading, 10)
//////            
//////            TextField("", text: $searchText)
//////                .placeholder(when: searchText.isEmpty) {
//////                    Text("Search an app name")
//////                        .foregroundColor(.white.opacity(0.6))
//////                        .fontWeight(.regular)
//////                }
//////                .foregroundColor(.white)
//////                .padding(10)
//////        }
//////        .background(Color.gray.opacity(0.2))
//////        .cornerRadius(10)
//////        .padding(.horizontal)
//////    }
//////}
//////
//////#Preview {
//////    OnboardingEssentials(viewModel: OnboardingViewModel.shared)
//////}
//////
//////extension View {
//////    func placeholder<Content: View>(
//////        when shouldShow: Bool,
//////        alignment: Alignment = .leading,
//////        @ViewBuilder placeholder: () -> Content
//////    ) -> some View {
//////        ZStack(alignment: alignment) {
//////            if shouldShow {
//////                placeholder()
//////            }
//////            self
//////        }
//////    }
//////}
////
////import SwiftUI
////
////struct OnboardingEssentials: View {
////    @ObservedObject var viewModel = OnboardingViewModel.shared
////    @State private var searchText = ""
////    
////    @State private var showToast = false
////    @State private var toastMessage = ""
////    
////    var filteredApps: [String] {
////        if searchText.isEmpty {
////            return FirebaseDataViewModel.shared.onlyAppName
////        } else {
////            return FirebaseDataViewModel.shared.onlyAppName.filter { $0.localizedCaseInsensitiveContains(searchText) }
////        }
////    }
////    
////    var body: some View {
////        ZStack {
////            Color.black.edgesIgnoringSafeArea(.all)
////            
////            VStack {
////                Text("Pick Essential Apps")
////                    .foregroundStyle(.white)
////                    .font(.largeTitle)
////                    .fontWeight(.semibold)
////                Text("Let's start with these apps. You can")
////                    .foregroundStyle(.white)
////                    .font(.headline)
////                    .fontWeight(.regular)
////                HStack{
////                    Spacer()
////                    Text("change them later")
////                        .foregroundStyle(.white)
////                        .font(.headline)
////                        .fontWeight(.regular)
////                        .padding(.leading)
////                    Spacer()
////                    Button {
////                        //restart the firebaseprocess again
////                    } label: {
////                        Text("Restart")
////                            .foregroundStyle(.white)
////                    }
////                    .padding(.trailing)
////
////                }
////         
////                
////                searchBox()
////                
////                List(filteredApps, id: \.self) { appName in
////                    HStack {
////                        Text(appName)
////                            .foregroundStyle(.white)
////                            .font(.headline)
////                            .fontWeight(.light)
////                            .padding()
////                        Spacer()
////                        Button(action: {
////                            toggleSelection(for: appName)
////                        }) {
////                            Image(systemName: viewModel.selectedAppName.contains(appName) ? "checkmark" : "plus")
////                                .foregroundColor(viewModel.selectedAppName.contains(appName) ? .green : .white)
////                                .font(.title2)
////                        }
////                        .padding()
////                    }
////                    .listRowBackground(Color.gray.opacity(0.2))
////                    .background(
////                        RoundedRectangle(cornerRadius: 0)
////                            .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
////                    )
////                    .listRowInsets(EdgeInsets())
////                }
////                .scrollContentBackground(.hidden)
////            }
////            
////            // Toast view
////            if showToast {
////                VStack {
////                    Spacer()
////                    Text(toastMessage)
////                        .padding()
////                        .background(Color.red.opacity(0.9))
////                        .foregroundColor(.white)
////                        .cornerRadius(10)
////                        .padding(.bottom, 20)
////                        .transition(.move(edge: .bottom).combined(with: .opacity))
////                        .animation(.easeInOut, value: showToast)
////                }
////            }
////        }
////    }
////    
////    private func toggleSelection(for appName: String) {
////        if let index = viewModel.selectedAppName.firstIndex(of: appName) {
////            viewModel.selectedAppName.remove(at: index)
////        } else if viewModel.selectedAppName.count < 6 {
////            viewModel.selectedAppName.append(appName)
////        } else {
////            toastMessage = "You can select up to 6 apps only."
////            showToast = true
////            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
////                showToast = false
////            }
////        }
////    }
////    
////    private func searchBox() -> some View {
////        HStack {
////            Image(systemName: "magnifyingglass")
////                .foregroundColor(.gray)
////                .padding(.leading, 10)
////            
////            TextField("", text: $searchText)
////                .placeholder(when: searchText.isEmpty) {
////                    Text("Search an app name")
////                        .foregroundColor(.white.opacity(0.6))
////                        .fontWeight(.regular)
////                }
////                .foregroundColor(.white)
////                .padding(10)
////        }
////        .background(Color.gray.opacity(0.2))
////        .cornerRadius(10)
////        .padding(.horizontal)
////    }
////}
////
////#Preview {
////    OnboardingEssentials(viewModel: OnboardingViewModel.shared)
////}
////
////extension View {
////    func placeholder<Content: View>(
////        when shouldShow: Bool,
////        alignment: Alignment = .leading,
////        @ViewBuilder placeholder: () -> Content
////    ) -> some View {
////        ZStack(alignment: alignment) {
////            if shouldShow {
////                placeholder()
////            }
////            self
////        }
////    }
////}
//
//
//
//import SwiftUI
//
//struct OnboardingEssentials: View {
//    @ObservedObject var viewModel = OnboardingViewModel.shared
//    @State private var searchText = ""
//    @State private var showToast = false
//    @State private var toastMessage = ""
//    @State private var isLoading = true
//    
//    var filteredApps: [String] {
//        if searchText.isEmpty {
//            return FirebaseDataViewModel.shared.onlyAppName
//        } else {
//            return FirebaseDataViewModel.shared.onlyAppName.filter { $0.localizedCaseInsensitiveContains(searchText) }
//        }
//    }
//    
//    var body: some View {
//        ZStack {
//            Color.black.edgesIgnoringSafeArea(.all)
//            
//            VStack {
//                Text("Pick Essential Apps")
//                    .foregroundStyle(.white)
//                    .font(.largeTitle)
//                    .fontWeight(.semibold)
//                
//                Text("Let's start with these apps. You can")
//                    .foregroundStyle(.white)
//                    .font(.headline)
//                    .fontWeight(.regular)
//                
//                HStack {
//                    Spacer()
//                    Text("change them later")
//                        .foregroundStyle(.white)
//                        .font(.headline)
//                        .fontWeight(.regular)
//                        .padding(.leading)
//                    
//                    Spacer()
//                    
//                    Button {
//                        loadData()
//                    } label: {
//                        Text("Restart")
//                            .foregroundStyle(.white)
//                    }
//                    .padding(.trailing)
//                }
//                
//                searchBox()
//                
//                if isLoading {
//                    ProgressView()
//                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
//                        .padding()
//                } else {
//                    List(filteredApps, id: \.self) { appName in
//                        HStack {
//                            Text(appName)
//                                .foregroundStyle(.white)
//                                .font(.headline)
//                                .fontWeight(.light)
//                                .padding()
//                            
//                            Spacer()
//                            
//                            Button(action: {
//                                toggleSelection(for: appName)
//                            }) {
//                                Image(systemName: viewModel.selectedAppName.contains(appName) ? "checkmark" : "plus")
//                                    .foregroundColor(viewModel.selectedAppName.contains(appName) ? .green : .white)
//                                    .font(.title2)
//                            }
//                            .padding()
//                        }
//                        .listRowBackground(Color.gray.opacity(0.2))
//                        .background(
//                            RoundedRectangle(cornerRadius: 0)
//                                .stroke(Color.white.opacity(0.1), lineWidth: 0.5)
//                        )
//                        .listRowInsets(EdgeInsets())
//                    }
//                    .scrollContentBackground(.hidden)
//                }
//            }
//            
//            // Toast view
//            if showToast {
//                VStack {
//                    Spacer()
//                    Text(toastMessage)
//                        .padding()
//                        .background(Color.red.opacity(0.9))
//                        .foregroundColor(.white)
//                        .cornerRadius(10)
//                        .padding(.bottom, 20)
//                        .transition(.move(edge: .bottom).combined(with: .opacity))
//                        .animation(.easeInOut, value: showToast)
//                }
//            }
//        }
//        .onAppear {
//            loadData()
//        }
//    }
//    
//    private func toggleSelection(for appName: String) {
//        if let index = viewModel.selectedAppName.firstIndex(of: appName) {
//            viewModel.selectedAppName.remove(at: index)
//        } else if viewModel.selectedAppName.count < 6 {
//            viewModel.selectedAppName.append(appName)
//        } else {
//            toastMessage = "You can select up to 6 apps only."
//            showToast = true
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                showToast = false
//            }
//        }
//    }
//    
//    private func loadData() {
//        isLoading = true
//        FirebaseDataViewModel.shared. { success in
//            isLoading = false
//            if !success || FirebaseDataViewModel.shared.onlyAppName.isEmpty {
//                toastMessage = "No internet connection. Tap Restart to try again."
//                showToast = true
//                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
//                    showToast = false
//                }
//            }
//        }
//    }
//    
//    private func searchBox() -> some View {
//        HStack {
//            Image(systemName: "magnifyingglass")
//                .foregroundColor(.gray)
//                .padding(.leading, 10)
//            
//            TextField("", text: $searchText)
//                .placeholder(when: searchText.isEmpty) {
//                    Text("Search an app name")
//                        .foregroundColor(.white.opacity(0.6))
//                        .fontWeight(.regular)
//                }
//                .foregroundColor(.white)
//                .padding(10)
//        }
//        .background(Color.gray.opacity(0.2))
//        .cornerRadius(10)
//        .padding(.horizontal)
//    }
//}
//
//#Preview {
//    OnboardingEssentials(viewModel: OnboardingViewModel.shared)
//}
//
//extension View {
//    func placeholder<Content: View>(
//        when shouldShow: Bool,
//        alignment: Alignment = .leading,
//        @ViewBuilder placeholder: () -> Content
//    ) -> some View {
//        ZStack(alignment: alignment) {
//            if shouldShow {
//                placeholder()
//            }
//            self
//        }
//    }
//}


import SwiftUI

struct OnboardingEssentials: View {
    @ObservedObject var viewModel = OnboardingViewModel.shared
    @State private var searchText = ""
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var isLoading = true
    
    // Filter apps by search text
    var filteredApps: [String] {
        if searchText.isEmpty {
            return FirebaseDataViewModel.shared.onlyAppName
        } else {
            return FirebaseDataViewModel.shared.onlyAppName.filter {
                $0.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(spacing: 16) {
                Text("Pick Essential Apps")
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .fontWeight(.semibold)
                    .padding(.top, 30)
                
                Text("Let's start with these apps. You can change them later.")
                    .foregroundColor(.white)
                    .font(.headline)
                    .fontWeight(.regular)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                HStack {
                    Spacer()

                    Button(action: loadData) {
                        Text("Reload")
                            .foregroundColor(.white)
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                            .background(Color.gray.opacity(0.4))
                            .cornerRadius(8)
                    }
                    .padding(.trailing)
                     
                }
                
                searchBox()
                
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .padding()
                } else {
                    List {
                        ForEach(filteredApps, id: \.self) { appName in
                            HStack {
                                Text(appName)
                                    .foregroundColor(.white)
                                    .font(.headline)
                                    .fontWeight(.light)
                                    .padding(.vertical, 6)
                                
                                Spacer()
                                
                                Button {
                                    toggleSelection(for: appName)
                                } label: {
                                    Image(systemName: viewModel.selectedAppName.contains(appName) ? "checkmark" : "plus")
                                        .foregroundColor(viewModel.selectedAppName.contains(appName) ? .green : .white)
                                        .font(.title2)
                                }
                                .buttonStyle(PlainButtonStyle())
                                .padding(.vertical, 6)
                            }
                            .listRowBackground(Color.gray.opacity(0.2))
                        }
                    }
                    .listStyle(PlainListStyle())
                    .scrollContentBackground(.hidden)
                    .padding(.horizontal)
                }
            }
            
            // Toast
            if showToast {
                VStack {
                    Spacer()
                    Text(toastMessage)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.red.opacity(0.9))
                        .cornerRadius(10)
                        .padding(.bottom, 20)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .animation(.easeInOut, value: showToast)
                }
                .zIndex(1)
            }
        }
        .onAppear(perform: loadData)
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
    
    private func loadData() {
        
        FirebaseDataViewModel.shared.prepareAppList()
        isLoading = true
        FirebaseDataViewModel.shared.fetchAppNames { appNames in
            DispatchQueue.main.async {
                isLoading = false
                if appNames.isEmpty {
                    showToastMessage("Tap Reload to try again.")
                } else {
                    // use appNames
                }
            }
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
    
    private func searchBox() -> some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding(.leading, 10)
            
            TextField("", text: $searchText)
                .placeholder(when: searchText.isEmpty) {
                    Text("Search an app name")
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
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content
    ) -> some View {
        ZStack(alignment: alignment) {
            if shouldShow {
                placeholder()
            }
            self
        }
    }
}

#Preview {
    OnboardingEssentials()
}
