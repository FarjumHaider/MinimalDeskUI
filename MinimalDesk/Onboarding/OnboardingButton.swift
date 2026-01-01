//
//  OnboardingContinue.swift
//  MinimalDesk
//
//  Created by Ajijul Hakim Riad on 8/12/24.
//

import SwiftUI

struct OnboardingButton: View {
    var text: String = "Continue"
    var bgOpacity = 1.0
    
    var body: some View {
        Text(text)
            .foregroundColor(Color("textColor"))
            .font(.system(size: 20, weight: .medium))
            .frame(width: UIScreen.main.bounds.width * 0.90, height: 60)
            .background(Color("whiteColor"))
            .cornerRadius(15)
            .padding(.bottom, 20)
    }
}

#Preview {
    OnboardingButton()
}
