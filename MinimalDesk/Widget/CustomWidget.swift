//
//  ContentView.swift
//  MinimalDesk
//
//  Created by Sadiqul Amin on 6/7/24.
//

import SwiftUI
import Firebase

struct CustomWidget: View {
    @Environment(\.dismiss) var dismiss
    
    @State var heightToSet:CGFloat =  0
    @State var widthToSet:CGFloat =  0
    @State var gap:CGFloat = 0
    @State var bottomGap:CGFloat = 0
    @State var gapNeedToGive:CGFloat = 0
    
    @State var widgetBackground: String
    @State var fontColor: String
    @State var fontType: String
    @State var alignment: String
    @State var space: Double
    @State var fontSize: Int
    @State var widget: Int
    
    @State var presentColorView = false
    @State private var isWidgetListPresented = false
    @State private var isCustomWallPaperPressed = false
    @State private var isFontListPresented = false
    @State private var isDoneButtonDisabled = true
    
    let colorHexList = [
        "#F4EADE",
        "#FFDFE0",
        "#E1EBEA",
        "#D5EAEB",
        "#F9DDB8",
        "#F1F3CE",
        "#DCE0CF",
        "#EFEEEA",
        "#EBDCB1",
        "#C4DFE6",
        "#FFE2D0",
        "#E5DCDF"
    ]
    
    private let viewModel = WidgetViewModel.shared
    
    init() {
        widgetBackground = viewModel.favAppWidgetConfig.backgroundColor
        //fontColor = Color(hex: viewModel.favAppWidgetConfig.fontColor)
        fontColor = viewModel.favAppWidgetConfig.fontColor
        fontType = viewModel.favAppWidgetConfig.fontType
        alignment = viewModel.favAppWidgetConfig.alignment
        space = viewModel.favAppWidgetConfig.spacing
        fontSize = viewModel.favAppWidgetConfig.fontSize
        widget = viewModel.favAppWidgetConfig.maxNumberOfApps
    }
    
    var body: some View {
        VStack() {
            //Color("backgroundColor")
                //.ignoresSafeArea()
//            Color.black

            
            HStack {
                Text("Pagination One")
                Image(systemName: "chevron.down")
                    .font(.system(size: 20))
                    .foregroundColor(.black)

                Spacer()

                Text("Done")
                    .font(.system(size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.blue)
                    .onTapGesture {
                        guard isDoneButtonDisabled == false else { return }
                        
                        viewModel.setNewFavWidgetConfig()
                        dismiss()
                    }

            }
            .padding()
            
                ScrollView(showsIndicators: false) {
                    VStack() {
                        
                        Text("Background Color")
                            .foregroundColor(Color(hex: "#646464"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                ForEach(colorHexList, id: \.self) { hex in
                                    
                                    //VStack {
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(hex: hex))                      // Background color of circle
                                        .overlay(                               // Add border using overlay
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    isSelected(value1: widgetBackground, value2: hex ) ,
                                                    // No border when not selected
                                                    lineWidth: 2
                                                )
                                        )
                                        .frame(width: 40, height: 40)
                                        //.cornerRadius(16)
                                        .onTapGesture { widgetBackground = hex }
                                    ///}
                                    
                                }
                            }
                            .padding(.horizontal, 14)
                            //.padding(.leading, viewModel.cards <= 1 ? (screenWidth * 0.30) / 2.0 : 0)
                        }
                        //.padding(.top,15)
                        .onChange(of: widgetBackground) { _, _ in
                            guard viewModel.favAppWidgetConfig.backgroundColor != widgetBackground else { return }
                            
                            viewModel.favAppWidgetConfig.backgroundColor = widgetBackground
                            isDoneButtonDisabled = false
                        }
                        //.ignoresSafeArea()
                        //.scrollTargetLayout()
                        
                    }
                    
                    VStack {
                        Text("Text Color")
                            .foregroundColor(Color(hex: "#646464"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                        
                        ScrollView(showsIndicators: false) {
                            VStack() {
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 14) {
                                        ForEach(colorHexList, id: \.self) { hex in
                                            
                                            //VStack {
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(Color(hex: hex))                      // Background color of circle
                                                .overlay(                               // Add border using overlay
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(
                                                            isSelected(value1: fontColor, value2: hex ) ,
                                                            // No border when not selected
                                                            lineWidth: 2
                                                        )
                                                )
                                                .frame(width: 40, height: 40)
                                                //.cornerRadius(16)
                                                .onTapGesture { fontColor = hex }
                                            ///}
                                            
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                    //.padding(.leading, viewModel.cards <= 1 ? (screenWidth * 0.30) / 2.0 : 0)
                                }
                                .onChange(of: fontColor) { _, _ in
                                    guard viewModel.favAppWidgetConfig.fontColor != fontColor else { return }
                                    
                                    viewModel.favAppWidgetConfig.fontColor = fontColor
                                    isDoneButtonDisabled = false
                                }

                                //.ignoresSafeArea()
                                //.scrollTargetLayout()
                                
                            }
                        }
                    }
                    
                    Text("Font Style")
                    Text("Alignment")
                    Text("Font Size")
                    Text("Spacing")
                }
            
            
 
            
        }
        //.padding()
        .background(Color.white)
        //.background(Color("backgroundColor"))
//        .onAppear {
//            gap = 20.0
//            widthToSet = (screenWidth - 3 * gap) / 2.0
//            bottomGap = (screenHeight - 3 * widthToSet - 4*gap - 70) / 3.0
//            gapNeedToGive = (screenWidth - 3*30)/3
//        }
    }
}

private extension CustomWidget {
    func isSelected(value1: String, value2: String) -> Color {
        value1 == value2 ? .blue : .clear
    }
}

#Preview {
    CustomWidget()
}


//extension Color {
//    init(hex: String) {
//        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
//        var int: UInt64 = 0
//        Scanner(string: hex).scanHexInt64(&int)
//
//        let r = Double((int >> 16) & 0xFF) / 255
//        let g = Double((int >> 8) & 0xFF) / 255
//        let b = Double(int & 0xFF) / 255
//
//        self.init(red: r, green: g, blue: b)
//    }
//}
