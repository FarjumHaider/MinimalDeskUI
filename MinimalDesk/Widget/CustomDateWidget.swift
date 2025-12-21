//
//  CustomDateWidget.swift
//  MinimalDesk
//
//  Created by Haider on 20/12/25.
//

import SwiftUI

struct CustomDateWidget: View {
    
    var index: Int = 1
//    var selectedTheme: String = ""
//    
    @State var widgetBackground: Color
    
    private let viewModel = WidgetViewModel.shared
    
    init() {
//        self.index = index
//        self.selectedTheme = selectedTheme
        widgetBackground = Color(hex: viewModel.dateConfig.arr[0].backgroundColor)
    }
    
    let backgroundColorHexList = [
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
        "#E5DCDF",
        "#000000",
    ]
    
    var backgroundColorList: [Color] {
        backgroundColorHexList.compactMap { Color(hex: $0) }
    }
    
    var body: some View {
        VStack {
            
            Text("Background Color")
                .foregroundColor(Color(hex: "#646464"))
                .font(.system(size: 16))
                .fontWeight(.semibold)
                .padding([.top, .bottom], 10)
                .frame(width: screenWidth * 0.92, alignment: .leading)
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 14) {
                    
                    ZStack {
                        Image("palette")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 40, height: 40)
                            .clipShape(RoundedRectangle(cornerRadius: 16))
                            .allowsHitTesting(false)
                        
                        ColorPicker("", selection: $widgetBackground, supportsOpacity: false)
                            .labelsHidden()
                            .frame(width: 40, height: 40)
                            .opacity(0.02) // invisible but tappable
                    }
                    
                    ForEach(backgroundColorList, id: \.self) { hex in
                        
                        //VStack {
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(hex: hex.toHex()!))                // Background color
                            .overlay(                               // Add border using overlay
                                RoundedRectangle(cornerRadius: 16)
                                    .stroke(
                                        isSelected(value1: widgetBackground.toHex()!, value2: hex.toHex()! ) ,
                                        lineWidth: 1
                                    )
                            )
                            .frame(width: 40, height: 40)
                        //.cornerRadius(16)
                            .onTapGesture { widgetBackground = hex }
                        ///}
                        
                    }
                }
                .padding(.horizontal, 14)
            }
            .onChange(of: widgetBackground) { _, _ in
                
                print("Farjum in 1 \(widgetBackground.toHex())")
                
                guard let backgroundcolorHex = widgetBackground.toHex(),
                      backgroundcolorHex != viewModel.dateConfig.arr[0].backgroundColor else { return }
                
                print("Farjum out 2 \(widgetBackground.toHex())")
                viewModel.dateConfig.arr[0].backgroundColor = backgroundcolorHex
                
                viewModel.setDateWidgetConfig()
                //viewModel.setTopWidget(theme: selectedTheme)
                //isDoneButtonDisabled = false
            }
        }
    }
}

private extension CustomDateWidget {
    func isSelected(value1: String, value2: String) -> Color {
        value1 == value2 ? .blue : .clear
    }
    
    func isSelectedAlignment(value1: String, value2: String) -> Color {
        value1 == value2 ? .blue : .clear
    }
    
}

#Preview {
    CustomDateWidget()
}
