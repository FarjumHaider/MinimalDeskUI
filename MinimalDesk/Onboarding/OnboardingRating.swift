//
//  OnboardingRating.swift
//  MinimalDesk
//
//  Created by Haider on 28/12/25.
//

import SwiftUI

struct OnboardingRating: View {
    
    private let screenWidth = UIScreen.main.bounds.width
    private let screenHeight = UIScreen.main.bounds.height
    var body: some View {
        
        ZStack {
            Image("rating")
                .resizable()
                .scaledToFit()
                .frame(width: screenWidth * 0.85, height: screenHeight * 0.85)
                .offset(y: -50)
                //.padding(.vertical, 40)
//                .overlay(alignment: .bottom) {
//                    LinearGradient(
//                        colors:
//                            [
//                                .clear,
//                                Color("backgroundColor").opacity(0.4),
//                                Color("backgroundColor").opacity(0.8)
//                            ],
//                        startPoint: .top,
//                        endPoint: .bottom
//                    )
//                    .frame(height: 180)
//                }
            //star
            HStack {
                ForEach(0..<5) { index in
                    Image(systemName: "star.fill")
                        //.renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .padding(.horizontal, 5)
                }
            }
            .offset(y: 180)
            
            Text("Rate us")
                //.multilineTextAlignment(.center)
                .foregroundColor(Color("textColor"))
                .font(.system(size: 24, weight: .medium))
                .offset(y: 230)
            
            Text("If you find it helpful, please take a moment")
                //.multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "#646464"))
                .font(.system(size: 16))
                .offset(y: 280)
            Text("to rate us in the App Store. Your support")
                //.multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "#646464"))
                .font(.system(size: 16))
                .offset(y: 305)
            
            Text("helps us grow and improve!")
                //.multilineTextAlignment(.center)
                .foregroundColor(Color(hex: "#646464"))
                .font(.system(size: 16))
                .offset(y: 330)
                .padding()
                

        }
    }
}

#Preview {
    OnboardingRating()
}
