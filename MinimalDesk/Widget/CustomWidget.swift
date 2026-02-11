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
    
    enum WidgetType {
        case favApp
        case todolist
    }
    
    private let viewModel = WidgetViewModel.shared
    let widgetType: WidgetType
    
    @State var heightToSet:CGFloat =  0
    @State var widthToSet:CGFloat =  0
    @State var gap:CGFloat = 0
    @State var bottomGap:CGFloat = 0
    @State var gapNeedToGive:CGFloat = 0
    
    @State var widgetBackground: Color
    @State var fontColor: Color
    @State var fontType: String
    @State var fontWeight: String
    @State var alignment: String
    @State var space: Double
    @State var fontSize: Double
    @State var widget: Int
    @State var caseText: String
    
    @State var presentColorView = false
    @State private var isWidgetListPresented = false
    @State private var isCustomWallPaperPressed = false
    @State private var isFontListPresented = false
    @State private var isDoneButtonDisabled = true
    @State private var shouldShowProgressView = false
    //@State private var showPicker = false
    @State private var paletteColor = ""
    
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
    
    let gradientColorsHex: [String] = [
        "#EA84DD", "#97E3EF",
        "#EB5372", "#F3B39D",
        "#A9A0FF", "#CD81E7",
        "#FFE3FB", "#C4F7FF",
        "#F08AE7", "#FF557C",
        "#6190E8", "#A7BFE8",
        "#4AFADF", "#E0F793",
        "#DCEA7A", "#BB9BF7",
        "#F6CD68", "#FF9B6A",
        "#F2D850", "#F657AA",
        "#FFB082", "#FF67E2",
        "#8575FA", "#D77CED",
        "#04BEFD", "#86FBB7",
        "#EA8A97", "#AEBBF3",
        "#37F0CB", "#EEED40",
        "#F6C6F9", "#AC93FF",
        "#FF8AAD", "#9FFFAD",
        "#55BBF9", "#A9FCB9",
        "#EF629F", "#EECDC3",
        "#9CE9A4", "#D6718E",
        "#EF85FC", "#8686FF",
        "#FACCC1", "#FDA7A7",
        "#7F8DC3", "#ED99AE",
        "#FDD648", "#FA7C90",
        "#BA94F9", "#8572F0",
        "#767AE5", "#F3DCE4",
        "#FFD900", "#FF6B90",
        "#FF7F66", "#E03883",
        "#00B1C0", "#95E587",
        "#F9C58D", "#F492F0",
        "#9FEDF9", "#F7C7C3",
        "#F0FD89", "#A4E018",
        "#FF0097", "#FC7373",
        "#6C94EE", "#11CDF7",
        "#FF4370", "#FFAF98",
        "#27B7E9", "#E078F1",
        "#13E1F9", "#8AE7AD",
        "#F7857E", "#CCFAD2",
        "#FCBC9C", "#6EE7A8",
        "#EFA2AC", "#FED8DC",
        "#FA4545", "#F57073",
        "#FA7099", "#FF7040",
        "#F094FA", "#F5576E",
        "#FF144E", "#F17550",
        "#FF0845", "#97E3EF",
        "#FA4545", "#FAC74D",
        "#FF8C21", "#FFE040",
        "#FF8C21", "#F5576E",
        "#FF8C21", "#FF6121",
        "#FF8C21", "#FFB099",
        "#FF8C21", "#E5F294",
        "#CCC938", "#F2C754",
        "#A3DE61", "#F0CF29",
        "#EBC43D", "#FFD18F",
        "#F5ED47", "#80F5E8",
        "#F5FFA6", "#F5B080",
        "#F5FFA6", "#F5E380",
        "#D4FC79", "#96E6A1",
        "#84FAB0", "#8FD3F4",
        "#2AF598", "#009EFD",
        "#37ECBA", "#72AFD3",
        "#37ECBA", "#75D473",
        "#3A65D3", "#75D473",
        "#0538FF", "#70E3F5",
        "#0538FF", "#40FFC7",
        "#0538FF", "#6B57F5",
        "#1F4CFF", "#6197E4",
        "#0538FF", "#5799F7",
        "#0596FF", "#5799F7",
        "#30D8EE", "#3E89F5",
        "#3D8CFA", "#40FFC7",
        "#94EDFA", "#6B57F5",
        "#08F0FF", "#3C89F6",
        "#08E3FF", "#5799F7",
        "#08FFB8", "#5799F7",
        "#C238CC", "#B554F2",
        "#A6E8FF", "#B280F5",
        "#B23DEB", "#DE8FFF",
        "#3D73EB", "#DE8FFF",
        "#CCFFA6", "#B280F5",
        "#F3A6FF", "#B280F5"
    ]
    
    var gradientColorsList: [Color] {
        gradientColorsHex.compactMap { Color(hex: $0) }
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
    
    let fontColorHexList = [
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
    
    var fontColorList: [Color] {
        fontColorHexList.compactMap { Color(hex: $0) }
    }
    
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
    
    
    
    init(widgetType: WidgetType) {
        self.widgetType = widgetType

        switch widgetType {
        case .favApp:
            widgetBackground = Color(hex: viewModel.favAppWidgetConfig.backgroundColor)
            fontColor = Color(hex: viewModel.favAppWidgetConfig.fontColor)
            fontType = viewModel.favAppWidgetConfig.fontType
            fontWeight = viewModel.favAppWidgetConfig.fontWeight
            alignment = viewModel.favAppWidgetConfig.alignment
            space = viewModel.favAppWidgetConfig.spacing
            fontSize = viewModel.favAppWidgetConfig.fontSize
            widget = viewModel.favAppWidgetConfig.maxNumberOfApps
            caseText = viewModel.favAppWidgetConfig.caseText
            
        case .todolist:
            widgetBackground = Color(hex: viewModel.checkListWidgetConfig.backgroundColor)
            fontColor = Color(hex: viewModel.checkListWidgetConfig.fontColor)
            fontType = viewModel.checkListWidgetConfig.fontType
            fontWeight = viewModel.checkListWidgetConfig.fontWeight
            alignment = viewModel.checkListWidgetConfig.alignment
            space = viewModel.checkListWidgetConfig.spacing
            fontSize = viewModel.checkListWidgetConfig.fontSize
            widget = viewModel.checkListWidgetConfig.maxNumberOfApps
            caseText = viewModel.checkListWidgetConfig.caseText
        }
    }
    
    var body: some View {
        
        ZStack {
            
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
                            
                            switch widgetType {
                            case .favApp:
                                viewModel.setNewFavWidgetConfig()
                            case .todolist:
                                viewModel.setTodoWidgetConfig()
                            }
                            
                            //viewModel.setNewFavWidgetConfig()
                            showProgressView()
                            
                            //dismiss()
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
                            guard let backgroundcolorHex = widgetBackground.toHex() else { return }
                            switch widgetType {
                            case .favApp:
                                guard backgroundcolorHex != viewModel.favAppWidgetConfig.backgroundColor else { return }
                                viewModel.favAppWidgetConfig.backgroundColor = backgroundcolorHex
                            case .todolist:
                                guard backgroundcolorHex != viewModel.checkListWidgetConfig.backgroundColor else { return }
                                viewModel.checkListWidgetConfig.backgroundColor = backgroundcolorHex
                            }
                            isDoneButtonDisabled = false
                        }
                    }
                    
                    // Gradient Background Color
                    VStack {
                        Text("Gradient Background Color")
                            .foregroundColor(Color(hex: "#646464"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .padding([.top, .bottom], 10)
                            .frame(width: screenWidth * 0.92, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                
                                ForEach(gradientColorsList, id: \.self) { hex in
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(hex: hex.toHex()!))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    isSelected(value1: widgetBackground.toHex()!, value2: hex.toHex()! ) ,
                                                    lineWidth: 1
                                                )
                                        )
                                        .frame(width: 40, height: 40)
                                        .onTapGesture { widgetBackground = hex }
                                }
                            }
                            .padding(.horizontal, 14)
                        }
                        .onChange(of: widgetBackground) { _, _ in
//                            guard let backgroundcolorHex = widgetBackground.toHex(),
//                                  backgroundcolorHex != viewModel.favAppWidgetConfig.backgroundColor else { return }
//                            
//                            viewModel.favAppWidgetConfig.backgroundColor = backgroundcolorHex
//                            isDoneButtonDisabled = false
                            
                            guard let backgroundcolorHex = widgetBackground.toHex() else { return }
                            switch widgetType {
                            case .favApp:
                                guard backgroundcolorHex != viewModel.favAppWidgetConfig.backgroundColor else { return }
                                viewModel.favAppWidgetConfig.backgroundColor = backgroundcolorHex
                            case .todolist:
                                guard backgroundcolorHex != viewModel.checkListWidgetConfig.backgroundColor else { return }
                                viewModel.checkListWidgetConfig.backgroundColor = backgroundcolorHex
                            }
                            isDoneButtonDisabled = false
                        }
                    }
                    
                    VStack {
                        Text("Text Color")
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
                                    
                                    ColorPicker("", selection: $fontColor, supportsOpacity: false)
                                        .labelsHidden()
                                        .frame(width: 40, height: 40)
                                        .opacity(0.02) // invisible but tappable
                                }
                                
                                ForEach(fontColorList, id: \.self) { hex in
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(hex: hex.toHex()!))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    isSelected(value1: fontColor.toHex()!, value2: hex.toHex()! ) ,
                                                    lineWidth: 1
                                                )
                                        )
                                        .frame(width: 40, height: 40)
                                        .onTapGesture { fontColor = hex }
                                    
                                }
                            }
                            .padding(.horizontal, 14)
                        }
                        .onChange(of: fontColor) { _, _ in
//                            guard let fontColorHex = fontColor.toHex(),
//                                  fontColorHex != viewModel.favAppWidgetConfig.fontColor else { return }
//                            
//                            viewModel.favAppWidgetConfig.fontColor = fontColorHex
//                            isDoneButtonDisabled = false
                            
                            guard let fontColorHex = fontColor.toHex()else { return }
                            switch widgetType {
                            case .favApp:
                                guard fontColorHex != viewModel.favAppWidgetConfig.fontColor else { return }
                                viewModel.favAppWidgetConfig.fontColor = fontColorHex
                            case .todolist:
                                guard fontColorHex != viewModel.checkListWidgetConfig.fontColor else { return }
                                viewModel.checkListWidgetConfig.fontColor = fontColorHex
                            }
                            isDoneButtonDisabled = false
                        }
                    }
                    
                    // gradian
                    VStack {
                        Text("Gradient Text Color")
                            .foregroundColor(Color(hex: "#646464"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .padding([.top, .bottom], 10)
                            .frame(width: screenWidth * 0.92, alignment: .leading)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 14) {
                                
                                ForEach(gradientColorsList, id: \.self) { hex in
                                    RoundedRectangle(cornerRadius: 16)
                                        .fill(Color(hex: hex.toHex()!))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 16)
                                                .stroke(
                                                    isSelected(value1: fontColor.toHex()!, value2: hex.toHex()! ) ,
                                                    lineWidth: 1
                                                )
                                        )
                                        .frame(width: 40, height: 40)
                                        .onTapGesture { fontColor = hex }
                                }
                            }
                            .padding(.horizontal, 14)
                        }
                        .onChange(of: fontColor) { _, _ in
                            guard let fontColorHex = fontColor.toHex()else { return }
                            switch widgetType {
                            case .favApp:
                                guard fontColorHex != viewModel.favAppWidgetConfig.fontColor else { return }
                                viewModel.favAppWidgetConfig.fontColor = fontColorHex
                            case .todolist:
                                guard fontColorHex != viewModel.checkListWidgetConfig.fontColor else { return }
                                viewModel.checkListWidgetConfig.fontColor = fontColorHex
                            }
                            isDoneButtonDisabled = false
                        }
                    }
                
                    // Mark: Front style
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
                                        .background(fontWeight == option.weight ? Color("buttonColor") : Color.clear)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            fontWeight = option.weight
                                            switch widgetType {
                                            case .favApp:
                                                guard viewModel.favAppWidgetConfig.fontWeight != fontWeight else { return }
                                                viewModel.favAppWidgetConfig.fontWeight = fontWeight
                                            case .todolist:
                                                guard viewModel.checkListWidgetConfig.fontWeight != fontWeight else { return }
                                                viewModel.checkListWidgetConfig.fontWeight = fontWeight
                                            }
                                            isDoneButtonDisabled = false
                                        }
                                }
                            }
                        }
                        
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
                                        .background(fontType == fontDesing.name.lowercased() ? Color("buttonColor") : Color.clear)
                                        .cornerRadius(10)
                                        .onTapGesture {
                                            fontType = fontDesing.name.lowercased()
                                            switch widgetType {
                                            case .favApp:
                                                guard viewModel.favAppWidgetConfig.fontType != fontType else { return }
                                                viewModel.favAppWidgetConfig.fontType = fontType
                                            case .todolist:
                                                guard viewModel.checkListWidgetConfig.fontType != fontType else { return }
                                                viewModel.checkListWidgetConfig.fontType = fontType
                                            }
                                            isDoneButtonDisabled = false
                                        }
                                    
                                }
                            }
                        }
                    }
                    
                    VStack {
                        Text("Alignment")
                            .foregroundColor(Color(hex: "#646464"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .padding([.top, .bottom], 10)
                            .frame(width: screenWidth * 0.92, alignment: .leading)
                        
                        //Color(hex: "#E2E2E4")
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 30) {
                                Image(systemName: "align.horizontal.left")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(alignment == "left" ? Color("buttonColor") : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        alignment = "left"
                                    }
                                
                                Image(systemName: "align.horizontal.center")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(alignment == "hCenter" ? Color("buttonColor") : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        alignment = "hCenter"
                                    }
                                
                                Image(systemName: "align.horizontal.right")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(alignment == "right" ? Color("buttonColor") : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        alignment = "right"
                                    }
                                
                                Image(systemName: "align.vertical.top")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(alignment == "top" ? Color("buttonColor") : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        alignment = "top"
                                    }
                                
                                Image(systemName: "align.vertical.center")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(alignment == "vCenter" ? Color("buttonColor") : Color.clear)
                                    .cornerRadius(10)
                                    .onTapGesture {
                                        alignment = "vCenter"
                                    }
                                
                                Image(systemName: "align.vertical.bottom")
                                    .padding(.vertical, 10)
                                    .padding(.horizontal, 30)
                                    .background(alignment == "bottom" ? Color("buttonColor") : Color.clear)
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
                            switch widgetType {
                            case .favApp:
                                viewModel.favAppWidgetConfig.alignment = alignment
                            case .todolist:
                                viewModel.checkListWidgetConfig.alignment = alignment
                            }
                            isDoneButtonDisabled = false
                        }
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
                            .tint(Color.blue)
                            .onChange(of: fontSize) { oldValue, newValue in
                                guard oldValue != newValue else { return }
                                switch widgetType {
                                case .favApp:
                                    viewModel.favAppWidgetConfig.fontSize = fontSize
                                case .todolist:
                                    viewModel.checkListWidgetConfig.fontSize = fontSize
                                }
                                isDoneButtonDisabled = false
                            }
                    }
                    
                    VStack {
                        Text("Spacing")
                            .foregroundColor(Color(hex: "#646464"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .padding([.top, .bottom], 10)
                            .frame(width: screenWidth * 0.92, alignment: .leading)
                        
                        Slider(value: $space, in: 10...40, step: 1)
                            .frame(width: screenWidth * 0.92, alignment: .center)
                            .tint(Color.blue)
                            .onChange(of: space) { oldValue, newValue in
                                guard oldValue != newValue else { return }
                                switch widgetType {
                                case .favApp:
                                    viewModel.favAppWidgetConfig.spacing = space
                                case .todolist:
                                    viewModel.checkListWidgetConfig.spacing = space
                                }
                                isDoneButtonDisabled = false
                            }
                    }
                    
                    VStack {
                        Text("Case")
                            .foregroundColor(Color(hex: "#646464"))
                            .font(.system(size: 16))
                            .fontWeight(.semibold)
                            .padding([.top, .bottom], 10)
                            .frame(width: screenWidth * 0.92, alignment: .leading)
                        
                        HStack( spacing: 30) {
                            Text("AB")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(caseText == "uppercase" ? Color("buttonColor") : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    caseText = "uppercase"
                                }
                            //.textCase(.uppercase)
                            Text("Ab")
                                .padding(.vertical, 10)
                                .padding(.horizontal, 30)
                                .background(caseText == "default" ? Color("buttonColor") : Color.clear)
                                .cornerRadius(10)
                                .onTapGesture {
                                    caseText = "default"
                                }
                            //.textCase(.uppercase)
                        }
                        .onChange(of: caseText, { oldValue, newValue in
                            guard oldValue != newValue else { return }
                            switch widgetType {
                            case .favApp:
                                viewModel.favAppWidgetConfig.caseText = caseText
                            case .todolist:
                                viewModel.checkListWidgetConfig.caseText = caseText
                            }
                            isDoneButtonDisabled = false
                        })
                        .frame(width: screenWidth * 0.92, alignment: .leading)
                    }
                    
                }
            }
            .background(Color("whiteColor"))
            
            if shouldShowProgressView {
                Color.black.opacity(0.1)
                    .ignoresSafeArea()

                ProgressView()
                    .progressViewStyle(.circular)
                    .scaleEffect(1.5)
            }
            
        }
        .animation(.easeInOut, value: shouldShowProgressView)
    }
    
    private func showProgressView() {
        shouldShowProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.shouldShowProgressView = false
            dismiss()
        }
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

//#Preview {
//    CustomWidget()
//}

