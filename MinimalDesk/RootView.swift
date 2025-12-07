//
//  ContentView.swift
//  MinimalDesk
//
//  Created by Sadiqul Amin on 6/7/24.
//

import SwiftUI
import TabBarModule

struct RootView: View {
    @State private var item: Int = 0
    @State private var hasTappedAppLocker = false
    @State private var showSubscriptionSheet = false
    
    @AppStorage("subscribed") var subscribed: Bool = false
    
    var body: some View {
        TabBar(selection: $item) {
            NavigationView {
                AddView()
            }
            .tabItem(0) {
                Image("HomeNew")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundColor(item == 0 ? .blue : Color("tabGray"))
                    .font(.title3)
                Text("Home")
                    .font(.system(.footnote, design: .rounded).weight(item == 0 ? .bold : .medium))
                    .foregroundColor(item == 0 ? .blue : Color("tabGray"))
                    .padding(.top ,4)
            }
            
//            NavigationView {
//                Widget()
//            }
//            .tabItem(1) {
//                Image("WidgetsNew")
//                    .renderingMode(.template)
//                    .resizable()
//                    .frame(width: 24, height: 24)
//                    .foregroundColor(item == 1 ? .blue : Color("tabGray"))
//                    .font(.title3)
//                Text("Widget")
//                    .font(.system(.footnote, design: .rounded).weight(item == 1 ? .bold : .medium))
//                    .foregroundColor(item == 1 ? .blue : Color("tabGray"))
//                    .padding(.top ,5)
//            }
            //.navigationTitle("Less Phone")
            
//            Tutorials()
//                .tabItem(2) {
//                    Image("TuitorialsNew")
//                        .renderingMode(.template)
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                        .foregroundColor(item == 2 ? .blue : Color("tabGray"))
//                        .font(.title3)
//                    Text("Tutorials")
//                        .font(.system(.footnote, design: .rounded).weight(item == 2 ? .bold : .medium))
//                        .foregroundColor(item == 2 ? .blue : Color("tabGray"))
//                        .padding(.top ,5)
//                }
            
            AppLocker()
                .tabItem(1) {
                    Image("LockNew")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(item == 4 ? .blue : Color("tabGray"))
                        .font(.largeTitle)
                    Text("Lock")
                        .font(.system(.footnote, design: .rounded).weight(item == 1 ? .bold : .medium))
                        .foregroundColor(item == 1 ? .blue : Color("tabGray"))
                        .padding(.top ,4)
                }
            
            CycleView()
                .tabItem(2) {
                    Image("CycleNew")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(item == 2 ? .blue : Color("tabGray"))
                        .font(.title3)
                    Text("Cycle")
                        .font(.system(.footnote, design: .rounded).weight(item == 2 ? .bold : .medium))
                        .foregroundColor(item == 2 ? .blue : Color("tabGray"))
                        .padding(.top ,4)
                }
            
            ChecklistView()
                .tabItem(3) {
                    Image("ChecklistNew")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(item == 3 ? .blue : Color("tabGray"))
                        .font(.largeTitle)
                    Text("Lock")
                        .font(.system(.footnote, design: .rounded).weight(item == 3 ? .bold : .medium))
                        .foregroundColor(item == 3 ? .blue : Color("tabGray"))
                        .padding(.top ,4)
                }
            
//            Settings()
//                .tabItem(4) {
//                    Image("Settings")
//                        .renderingMode(.template)
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                        .foregroundColor(item == 4 ? .blue : .white)
//                        .font(.title3)
//                    Text("Settings")
//                        .font(.system(.footnote, design: .rounded).weight(item == 4 ? .bold : .medium))
//                        .foregroundColor(item == 4 ? .blue : .white)
//                        .padding(.top ,5)
//                }
            
//                .tabItem(5) {
//                    Image("CycleNew")
//                        .renderingMode(.template)
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                        .foregroundColor(item == 4 ? .blue : .white)
//                        .font(.title3)
//                    Text("CycleNew")
//                        .font(.system(.footnote, design: .rounded).weight(item == 4 ? .bold : .medium))
//                        .foregroundColor(item == 4 ? .blue : .white)
//                        .padding(.top ,5)
//                }
//
//                .tabItem(6) {
//                    Image("Settings")
//                        .renderingMode(.template)
//                        .resizable()
//                        .frame(width: 24, height: 24)
//                        .foregroundColor(item == 4 ? .blue : .white)
//                        .font(.title3)
//                    Text("Settings")
//                        .font(.system(.footnote, design: .rounded).weight(item == 4 ? .bold : .medium))
//                        .foregroundColor(item == 4 ? .blue : .white)
//                        .padding(.top ,5)
//                }
            //[Color("backgroundColor")
        }
        .tabBarFill(
            .linearGradient(
                colors: [.white, .white],
                startPoint: .top, endPoint: .bottom
            )
        )
        .onChange(of: item) { newItem in
            if newItem == 1 { // App Locker tab selected
                if Store.shared.userHasActivePurchase() {
                    if !hasTappedAppLocker {
                        AppLockerViewModel.shared.requestAuthorization()
                        hasTappedAppLocker = true
                    }
                } else {
                    // Show subscription page full screen
                    showSubscriptionSheet = true
                }
            }
        }
  
    }
}

#Preview {
    RootView()
}

