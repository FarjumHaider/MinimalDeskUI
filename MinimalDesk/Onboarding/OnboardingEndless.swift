//
//  OnboardingEndless.swift
//  MinimalDesk
//
//  Created by Haider on 27/12/25.
//

import SwiftUI

struct OnboardingEndless: View {
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    var body: some View {
        
        ZStack {
            Image("majestic-tree")
                .resizable()
                .scaledToFill()
                //.ignoresSafeArea(.all)
                //.frame(width: screenWidth, height: screenHeight)
            //.padding(.top, 40)
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [
                            .clear,
                            Color("backgroundColor").opacity(0.4),
                            Color("backgroundColor").opacity(1.5)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 300)
                }
            
            Text("Endless")
            //.multilineTextAlignment(.center)
                .foregroundColor(Color("textColor"))
                .font(.system(size: 24, weight: .medium))
                .offset(y: 240)
            
            Text("scrolling Your screens quietly takes over your day")
            //.multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "#646464"))
                .font(.system(size: 17))
                .offset(y: 280)
            
            Text("over your day")
            //.multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "#646464"))
                .font(.system(size: 17))
                .offset(y: 300)
        }
        //.ignoresSafeArea()
        //}
        
        //        ZStack {
        //            Image("majestic-tree")
        //                //.renderingMode(.template)
        //                .resizable()
        //                .scaledToFill()
        //                .ignoresSafeArea(.all)
        //                //.foregroundColor(Color("backgroundColor"))
        //
        //            VStack{
        //                Text("Endless")
        //
        //                Text("scrolling Your screens quietly takes over your day")
        //
        //                Text("over your day")
        //            }
        //
        ////                .Color("backgroundColor")
        ////                .ignoresSafeArea()
        //        }
        //.ignoresSafeArea(.all)
    }
}

#Preview {
    OnboardingEndless()
}
