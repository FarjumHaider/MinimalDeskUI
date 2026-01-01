//
//  OnboardingLess.swift
//  MinimalDesk
//
//  Created by Haider on 27/12/25.
//

import SwiftUI

struct OnboardingLess: View {
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    
    @Environment(\.colorScheme) var colorScheme
    var body: some View {
        //ZStack {
            //Color.black.edgesIgnoringSafeArea(.all)
            //Life without the distraction
            
            ZStack {
                VStack {
                    Text("Life without the distraction")
                        .foregroundColor(Color("textColor"))
                        .font(.system(size: 17))
                        .frame(width: 252, height: 55)
                        .background(Color("whiteColor"))
                        .cornerRadius(60)
                        .padding(.vertical, 20)
                    
                    Image("frame")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.75, height: screenHeight * 0.65)
                        //.padding(.bottom, 10)
                        .overlay(alignment: .bottom) {

                            // 👇 Shadow / fade effect
//                            LinearGradient(
//                                colors: [
//                                    .clear,
//                                    Color.black.opacity(0.4),
//                                    Color.black.opacity(0.8)
//                                ],
//                                startPoint: .top,
//                                endPoint: .bottom
//                            )
//                            .frame(height: 180) // controls shadow height
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
                }
                
                Text("Less Phone")
                    //.multilineTextAlignment(.center)
                    .foregroundColor(Color.white)
                    .font(.system(size: 24, weight: .medium))
                    .offset(y: 180)
                
                Text("is designed to help you stay")
                    //.multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#646464"))
                    .font(.system(size: 17))
                    .offset(y: 220)
                Text("focused.")
                    //.multilineTextAlignment(.center)
                    .foregroundColor(Color(hex: "#646464"))
                    .font(.system(size: 17))
                    .offset(y: 240)
            }


            
        //}
    }
}

#Preview {
    OnboardingLess()
}
