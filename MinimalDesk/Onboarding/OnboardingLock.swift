//
//  OnboardingLock.swift
//  MinimalDesk
//
//  Created by Haider on 27/12/25.
//

import SwiftUI

struct OnboardingLock: View {
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        //ZStack {
            //Color.black.edgesIgnoringSafeArea(.all)
            //Life without the distraction
            
            ZStack {
                VStack {
                    Image("lockFrame")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.75, height: screenHeight * 0.65)
                        //.padding(.top, 40)
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
                            .frame(height: 300)
                        }
                }
                
                Text("Reclaim your time")
                    //.multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .medium))
                    .offset(y: 60)
                
                Text("Reduce screen time with out effort.")
                    //.multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#646464"))
                    .font(.system(size: 17))
                    .offset(y: 90)

                rectungularBox(with: "Transform your device from", and: "a distraction_ a tool")
                    .offset(y: 170)
                rectungularBox(with: "Scientifically designed to help you spend", and: "less time on your phone.")
                    .offset(y: 250)
                rectungularBox(with: "Get a clean screen without noise", and: "")
                    .offset(y: 330)
            }
        //}
    }
    
    //lockOnboarding
    private func rectungularBox(with upperText: String, and lowerText: String) -> some View {
        
        HStack(spacing: 0) {

            
            VStack(alignment: .leading) {
                Text(upperText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("textColor"))
                Text(lowerText)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color("textColor"))
            }
            .padding()
            
            Spacer()
            
            Image(systemName: "checkmark.circle")
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: 30, height: 30)
                .foregroundColor(Color("textColor"))
                //.fontWeight(.semibold)
                .padding(.horizontal, 15)
            
            
        }
        .frame(width: screenWidth * 0.90, height: 60)
        .background(Color("lockOnboarding"))
        .cornerRadius(18)
        
        
//        return VStack(alignment: .leading) {
//            Text(upperText)
//                .frame(width: .infinity)
//            Text(lowerText)
//                .frame(width: .infinity)
//        }
//        ///.foregroundColor(Color("textColor"))
//        .foregroundColor(Color(hex: "#646464"))
//        .font(.system(size: 14, weight: .light))
//        .frame(width: screenWidth * 0.90, height: 60)
//        .background(Color("lockOnboarding"))
//        .cornerRadius(18)
//        .padding(.bottom, 20)
    }
}

#Preview {
    OnboardingLock()
}
