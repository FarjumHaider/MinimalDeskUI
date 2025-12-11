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
    @State var fontWeight: String
    @State var alignment: String
    @State var space: Double
    @State var fontSize: Double
    @State var widget: Int
    
    @State var presentColorView = false
    @State private var isWidgetListPresented = false
    @State private var isCustomWallPaperPressed = false
    @State private var isFontListPresented = false
    @State private var isDoneButtonDisabled = true
    
    // A structure to convert String -> Font.Weight
    struct FontWeightConverter {
        let weightString: String
        
        var value: Font.Weight {
            switch weightString.lowercased() {
            case "ultralight": return .ultraLight
            case "thin": return .thin
            case "light": return .light
            case "regular": return .regular
            case "medium": return .medium
            case "semibold": return .semibold
            case "bold": return .bold
            case "heavy": return .heavy
            case "black": return .black
            default: return .regular
            }
        }
    }
    
    struct FontTypeConverter {
        let FontString: String
        
        var value: Font.Design {
            switch FontString.lowercased() {
            case "default": return .default
            case "serif": return .serif
            case "rounded": return .rounded
            case "monospaced": return .monospaced
            default: return .default
            }
        }
    }
    
    
    let BackgroundColorHexList = [
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
    
    let FontColorHexList = [
        "#F4EADE",
        "#000000",
        "#333333",
        "#666666",
        "#999999",
        "#B5B5B5",
        "#D3D3D3",
        "#E0E0E0",
        "#EFEFEF",
        "#F9F9F9",
        "#FFFFFF"
    ]
    
    struct FontWeightOption {
        let weight: String
        let name: String
    }
    
    let weightOptions: [FontWeightOption] = [
        FontWeightOption(weight: "ultralight", name: "Ultra Light"),
        FontWeightOption(weight: "thin", name: "Thin"),
        FontWeightOption(weight: "light", name: "Light"),
        FontWeightOption(weight: "regular", name: "Regular"),
        FontWeightOption(weight: "medium", name: "Medium"),
        FontWeightOption(weight: "semibold", name: "Semi Bold"),
        FontWeightOption(weight: "bold", name: "Bold"),
        FontWeightOption(weight: "heavy", name: "Heavy"),
        FontWeightOption(weight: "black", name: "Black")
    ]
    
    struct FontDesignOption: Identifiable {
        let id = UUID()
        let design: Font.Design
        let name: String
        let customFont: String
        let weight: Font.Weight
    }

    let fontDesigns: [FontDesignOption] = [
        FontDesignOption(design: .default, name: "Default", customFont: "Inter-Regular", weight: .medium),
        FontDesignOption(design: .serif, name: "Serif", customFont: "AveriaSerifLibre-Regular", weight: .light),
        FontDesignOption(design: .rounded, name: "Rounded", customFont: "Nunito-Regular", weight: .light),
        FontDesignOption(design: .monospaced, name: "Monospaced", customFont: "SpaceMono-Regular", weight: .regular)
    ]
    
    private let viewModel = WidgetViewModel.shared
    
    init() {
        widgetBackground = viewModel.favAppWidgetConfig.backgroundColor
        //fontColor = Color(hex: viewModel.favAppWidgetConfig.fontColor)
        fontColor = viewModel.favAppWidgetConfig.fontColor
        fontType = viewModel.favAppWidgetConfig.fontType
        fontWeight = viewModel.favAppWidgetConfig.fontWeight
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
                VStack {
                    
                    Text("Background Color")
                        .foregroundColor(Color(hex: "#646464"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding([.top, .bottom], 10)
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 14) {
                            ForEach(BackgroundColorHexList, id: \.self) { hex in
                                
                                //VStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color(hex: hex))                      // Background color of circle
                                    .overlay(                               // Add border using overlay
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(
                                                isSelected(value1: widgetBackground, value2: hex ) ,
                                                // No border when not selected
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
                        .padding([.top, .bottom], 10)
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    ScrollView(showsIndicators: false) {
                        VStack() {
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 14) {
                                    ForEach(FontColorHexList, id: \.self) { hex in
                                        
                                        //VStack {
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color(hex: hex))                      // Background color of circle
                                            .overlay(                               // Add border using overlay
                                                RoundedRectangle(cornerRadius: 16)
                                                    .stroke(
                                                        isSelected(value1: fontColor, value2: hex ) ,
                                                        // No border when not selected
                                                        lineWidth: 1
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
                
                VStack {
                    Text("Font Style")
                        .foregroundColor(Color(hex: "#646464"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding([.top, .bottom], 10)
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    // font weight
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(weightOptions, id: \.name) { option in
                                Text(option.name)
                                    .fontWeight(FontWeightConverter(weightString: option.weight).value)
                                    .padding(.vertical, 12.35)
                                    .padding(.horizontal, 19.76)
                                    .background(fontWeight == option.weight ? Color(hex: "#E2E2E4") : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        fontWeight = option.weight
                                        
                                        guard viewModel.favAppWidgetConfig.fontWeight != fontWeight else { return }
                                        
                                        viewModel.favAppWidgetConfig.fontWeight = fontWeight
                                        isDoneButtonDisabled = false
                                    }
                            }
                        }
                    }
                    
                    
//                        FontDesignOption(design: .default, name: "Default"),
//                        FontDesignOption(design: .serif, name: "Serif"),
//                        FontDesignOption(design: .rounded, name: "Rounded"),
//                        FontDesignOption(design: .monospaced, name: "Monospaced")
                    
//                        Text("Monospaced")
//                            .fontDesign(.default)
//                            //.font(.custom("SpaceMono-Bold", size: 20))
//
//                        Text("Monospaced")
//                            .fontDesign(.default)
//                            //.font(.custom("SpaceMono-Bold", size: 20))
//
//                        Text("Monospaced")
//                            .fontDesign(.serif)
//                            //.font(.custom("SpaceMono-Bold", size: 20))
//
//                        Text("Monospaced")
//                            .fontDesign(.rounded)
//                            //.font(.custom("SpaceMono-Bold", size: 20))
//
//                        Text("Monospaced")
//                            .fontDesign(.monospaced)
//                            //.font(.custom("SpaceMono-Bold", size: 20))
                    
                    
                    /// font design
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(fontDesigns) { fontDesing in
                                Text(fontDesing.name)
                                    //.font(.system(.footnote, design: fontDesing.design))
                                    .fontDesign(fontDesing.design)
                                    .fontWeight(fontDesing.weight)
                                    .font(Font.custom(fontDesing.customFont, size: 17))
                                    
                                    //.font(.system(size: 20, design: .))
                                    .padding(.vertical, 12.35)
                                    .padding(.horizontal, 19.76)
                                    .background(fontType == fontDesing.name.lowercased() ? Color(hex: "#E2E2E4") : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        fontType = fontDesing.name.lowercased()
                                        
                                        guard viewModel.favAppWidgetConfig.fontType != fontType else { return }
                                        
                                        viewModel.favAppWidgetConfig.fontType = fontType
                                        isDoneButtonDisabled = false
                                    }
                                
                            }
                        }
                        //.padding(.horizontal, 16)
                        //.padding(.leading, viewModel.cards <= 1 ? (screenWidth * 0.30) / 2.0 : 0)
                    }
//                        .onChange(of: fontColor) { _, _ in
//                            guard viewModel.favAppWidgetConfig.fontColor != fontColor else { return }
//
//                            viewModel.favAppWidgetConfig.fontColor = fontColor
//                            isDoneButtonDisabled = false
//                        }

                }
                
                VStack {
                    Text("Alignment")
                        .foregroundColor(Color(hex: "#646464"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding([.top, .bottom], 10)
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 30) {
                            Image(systemName: "align.horizontal.left")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(alignment == "left" ? Color(hex: "#E2E2E4") : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    alignment = "left"
                                }
                            
                            Image(systemName: "align.horizontal.center")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(alignment == "hCenter" ? Color(hex: "#E2E2E4") : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    alignment = "hCenter"
                                }
                            
                            Image(systemName: "align.horizontal.right")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(alignment == "right" ? Color(hex: "#E2E2E4") : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    alignment = "right"
                                }
                            
                            Image(systemName: "align.vertical.top")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(alignment == "top" ? Color(hex: "#E2E2E4") : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    alignment = "top"
                                }
                            
                            Image(systemName: "align.vertical.center")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(alignment == "vCenter" ? Color(hex: "#E2E2E4") : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    alignment = "vCenter"
                                }
                            
                            Image(systemName: "align.vertical.bottom")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(alignment == "bottom" ? Color(hex: "#E2E2E4") : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    alignment = "bottom"
                                }
                        }
                    }
                    .font(.system(size: 20))
                    .frame(width: screenWidth * 0.92, alignment: .leading)
                    .onChange(of: alignment) { oldValue, newValue in
                        guard oldValue != newValue else { return }
                        viewModel.favAppWidgetConfig.alignment = alignment
                        isDoneButtonDisabled = false
                    }
                    //.padding(.horizontal, 16)
                    
                }


                VStack {
                    Text("Font Size")
                        .foregroundColor(Color(hex: "#646464"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding([.top, .bottom], 10)
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    Slider(value: $fontSize, in: 10...40, step: 1)
                        .frame(width: screenWidth * 0.92, alignment: .center)
                        .tint(Color(hex: "#010101"))
                }
                

//                Slider(
//                    value: Binding(
//                        get: { Double(fontSize) },
//                        set: { fontSize = Int($0) }
//                    ),
//                    in: 10...40,
//                    step: 1
//                )
                VStack {
                    Text("Spacing")
                        .foregroundColor(Color(hex: "#646464"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding([.top, .bottom], 10)
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
                    Slider(value: $space, in: 10...40, step: 1)
                        .frame(width: screenWidth * 0.92, alignment: .center)
                        .tint(Color.black)
                }
                
                VStack {
                    Text("Case")
                        .foregroundColor(Color(hex: "#646464"))
                        .font(.system(size: 16))
                        .fontWeight(.semibold)
                        .padding([.top, .bottom], 10)
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    
//                    HStack(alignment: .leading) {
//                        Text("AB")
//                        Text("Ab")
//                    }
                    
                    HStack( spacing: 30) {
                        Text("AB")
                        Text("Ab")
                    }
                    .frame(width: screenWidth * 0.92, alignment: .leading)
                }

            }
            
            
 
            
        }
        //.padding()
        //.background(Color.white)
        .background(Color("backgroundColor"))
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
    
    func isSelectedAlignment(value1: String, value2: String) -> Color {
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
