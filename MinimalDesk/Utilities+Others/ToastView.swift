//
//  ToastView.swift
//  MinimalDesk
//
//  Created by Rakib Hasan on 23/9/24.
//
import SwiftUI

struct ToastView: View {
    let message: String
    
    var body: some View {
        VStack {
            Text(message)
                .multilineTextAlignment(.center)
                .foregroundColor(Color("textColor"))
                .padding(.vertical, 10)
                .padding(.horizontal, 20)
                //.background(Color.black.opacity(0.7))
                .cornerRadius(25)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .transition(.opacity)
    }
}

struct ActionCardToast: View {
    
    var title: String
    var subTitle: String
    var onCancel: () -> Void
    var onDelete: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text(title)
                .font(.headline)
                .multilineTextAlignment(.center)
            
            Text(subTitle)
                .font(.subheadline)
                .multilineTextAlignment(.center)
            
            HStack(spacing: 12) {
                
                Button(action: onCancel) {
                    Text("Cancel")
                        .frame(width: 100, height: 15)
                        .padding()
                        .background(Color.gray.opacity(0.15))
                        .cornerRadius(12)
                }
                
                Button(role: .destructive, action: onDelete) {
                    Text("Delete")
                        .frame(width: 100, height: 20)
                        .padding()
                        .background(Color.red)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(.ultraThinMaterial)
                .shadow(radius: 15)
        )
        .frame(width: 400, height: 100)
    }
}
