//
//  OnboardingIntro.swift
//  MinimalDesk
//
//  Created by Haider on 26/12/25.
//

import SwiftUI

struct OnboardingIntro: View {

    var body: some View {
        ZStack {
            Color("backgroundColor")
                .ignoresSafeArea()
            //Say Hello to your new, distraction-free iPhone
            VStack(alignment: .leading) {

                Text("Say Hello")
//                    .font(.largeTitle)
//                    .foregroundStyle(.white)
                    //.fontWeight(.semibold)
                Text("to your")
//                    .font(.headline)
//                    .foregroundStyle(.white)
//                    .fontWeight(.medium)
                Text("new, distraction-free")
//                    .font(.headline)
//                    .foregroundStyle(.white)
//                    .fontWeight(.medium)
                Text("iPhone")
//                    .font(.headline)
//                    .foregroundStyle(.white)
//                    .fontWeight(.medium)
            }
            .font(.system(size: 32))
            .foregroundColor(Color("textColor"))
        }
    }
}
