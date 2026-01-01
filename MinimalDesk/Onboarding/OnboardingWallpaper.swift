//
//  OnboardingWallpaper.swift
//  MinimalDesk
//
//  Created by Haider on 28/12/25.
//

import SwiftUI
import Photos

enum SelectedImage {
    case first
    case second
    case none
}

struct OnboardingWallpaper: View {
    
    @State private var showToast = false
    @State private var toastMessage = ""
    @State private var selected: SelectedImage = .none
    
    var body: some View {
        ZStack {
            VStack {
                
                Text("Watch Tutorial")
                    .foregroundColor(Color("textColor"))
                    .font(.system(size: 17))
                    .frame(width: 150, height: 42)
                    .background(Color("whiteColor"))
                    .cornerRadius(60)
                    .offset(y: 30)
                //.padding(.top, 80)
                
                ZStack {
                    
                    Image("wallpaperLight")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.60, height: screenHeight * 0.60)
                        .offset(x: selected == .first ? 0 : 80, y: -5)
                        .opacity(selected == .second ? 0 : 1)
                        .zIndex(selected == .first ? 1 : 0)
                        .scaleEffect(selected == .first ? 1.05 : 0.95)
                        //.blur(radius: selected == .first ? 0 : 3)
                        .animation(.easeInOut(duration: 0.4), value: selected)
                        .onTapGesture {
                            selected = .first
                            saveImageToGallery(imageName: "whiteWallpaper")
                        }
                    
                    Image("wallpaperDark")
                        .resizable()
                        .scaledToFit()
                        .frame(width: screenWidth * 0.50, height: screenHeight * 0.40)
                        .offset(x: selected == .second ? 0 : -30)
                        .opacity(selected == .first ? 0 : 1)
                        .zIndex(selected == .second ? 1 : 0)
                        .scaleEffect(selected == .second ? 1.05 : 0.95)
                        //.blur(radius: selected == .second ? 0 : 3)
                        .animation(.easeInOut(duration: 0.4), value: selected)
                        .onTapGesture {
                            saveImageToGallery(imageName: "blackWallpaper")
                            withAnimation(.easeInOut) {
                                selected = .second
                            }
                        }
                    //.padding(.top, 50)
                    
                    
                    //.padding(.top, 50)
                }
                
                VStack {
                    Text("Choose a wallpaper")
                    //.multilineTextAlignment(.center)
                        .foregroundColor(Color("textColor"))
                        .font(.system(size: 24, weight: .medium))
                        .padding(.bottom, 10)
                    //.offset(y: 280)
                    
                    Text("Do you use your phone in dark mode")
                    //.multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#646464"))
                        .font(.system(size: 16))
                    //.offset(y: 320)
                    Text("or light mode.")
                    //.multilineTextAlignment(.center)
                        .foregroundColor(Color(hex: "#646464"))
                        .font(.system(size: 16))
                    //.offset(y: 345)
                }
                .offset(y: -50)
            }
            
            if showToast {
                ToastView(message: toastMessage)
                    .onAppear {
                        handleToast()
                    }
            }
        }
    }
    
    private func saveImageToGallery(imageName: String) {
        let status = PHPhotoLibrary.authorizationStatus(for: .addOnly)
        
        if status == .notDetermined {
            PHPhotoLibrary.requestAuthorization(for: .addOnly) { newStatus in
                if newStatus == .authorized || newStatus == .limited {
                    saveImage(imageName: imageName)
                } else {
                    toastMessage = "Permission denied. Enable access in settings."
                    showToast = true
                }
            }
        } else if status == .authorized || status == .limited {
            saveImage(imageName: imageName)
        } else {
            toastMessage = "Permission denied. Enable access in settings."
            showToast = true
        }
    }
    
    private func saveImage(imageName: String) {
//        guard let index = index, index >= 0, index < sampleTrips.count else {
//            toastMessage = "Invalid image index!"
//            showToast = true
//            return
//        }
        
        //let imageName = "downloadWallpaper\(index + 1)"
        guard let image = UIImage(named: imageName) else {
            toastMessage = "Image \(imageName) not found!"
            showToast = true
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        toastMessage = "Image saved to gallery!"
        showToast = true
    }
    
    private func handleToast() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showToast = false
        }
    }
}

#Preview {
    OnboardingWallpaper()
}
