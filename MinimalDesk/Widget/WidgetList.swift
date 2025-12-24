//
//  WidgetList.swift
//  MinimalDesk
//
//  Created by Rakib Hasan on 17/7/24.
//

import SwiftUI
import WidgetKit

struct WidgetList: View {
    @Environment(\.dismiss) var dismiss
    
    //@ObservedObject private var viewModel = WidgetViewModel.shared
    
    private let viewModel = WidgetViewModel.shared
    
    @State private var selectedTheme: String = ""
    @State private var shouldShowProgressView = false
    
    @State private var selectedIndex: Int = 0
    
    //@State var fontColor: Color = .black
    //@State var widgetConfig: [FavAppWidgetConfig1]
    
    //@State private var isPresented = false
    
    @State var widgetBackground1: Color
    @State var widgetBackground2: Color
    @State var widgetBackground3: Color
    @State var widgetBackground4: Color
    @State var widgetBackground5: Color
    @State var widgetBackground6: Color
    @State var widgetBackground7: Color
    @State var widgetBackground8: Color
    
    @State var fontColor1: Color
    @State var fontColor2: Color
    @State var fontColor3: Color
    @State var fontColor4: Color
    @State var fontColor5: Color
    @State var fontColor6: Color
    @State var fontColor7: Color
    @State var fontColor8: Color
    
    @State private var showModal = false
    private let modalHeight = UIScreen.main.bounds.height / 3
    @State private var dragOffset: CGFloat = 0
    
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

        // ⚠️ skipped invalid RGB with emoji

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
    
    
    init() {
        //self.widgetConfig = viewModel.dateConfig.arr
        self.widgetBackground1 = Color(hex: viewModel.dateConfig.arr[0].backgroundColor)
        self.widgetBackground2 = Color(hex: viewModel.dateConfig.arr[1].backgroundColor)
        self.widgetBackground3 = Color(hex: viewModel.dateConfig.arr[2].backgroundColor)
        self.widgetBackground4 = Color(hex: viewModel.dateConfig.arr[3].backgroundColor)
        self.widgetBackground5 = Color(hex: viewModel.dateConfig.arr[4].backgroundColor)
        self.widgetBackground6 = Color(hex: viewModel.dateConfig.arr[5].backgroundColor)
        self.widgetBackground7 = Color(hex: viewModel.dateConfig.arr[6].backgroundColor)
        self.widgetBackground8 = Color(hex: viewModel.dateConfig.arr[7].backgroundColor)
        
        self.fontColor1 = Color(hex: viewModel.dateConfig.arr[0].fontColor)
        self.fontColor2 = Color(hex: viewModel.dateConfig.arr[1].fontColor)
        self.fontColor3 = Color(hex: viewModel.dateConfig.arr[2].fontColor)
        self.fontColor4 = Color(hex: viewModel.dateConfig.arr[3].fontColor)
        self.fontColor5 = Color(hex: viewModel.dateConfig.arr[4].fontColor)
        self.fontColor6 = Color(hex: viewModel.dateConfig.arr[5].fontColor)
        self.fontColor7 = Color(hex: viewModel.dateConfig.arr[6].fontColor)
        self.fontColor8 = Color(hex: viewModel.dateConfig.arr[7].fontColor)
    }
    
    // MARK: - Selected Background Binding
    private var selectedBackgroundBinding: Binding<Color> {
        Binding(
            get: {
                switch selectedIndex {
                case 0: return widgetBackground1
                case 1: return widgetBackground2
                case 2: return widgetBackground3
                case 3: return widgetBackground4
                case 4: return widgetBackground5
                case 5: return widgetBackground6
                case 6: return widgetBackground7
                case 7: return widgetBackground8
                default: return widgetBackground1
                }
            },
            set: { newValue in
                switch selectedIndex {
                case 0: widgetBackground1 = newValue
                case 1: widgetBackground2 = newValue
                case 2: widgetBackground3 = newValue
                case 3: widgetBackground4 = newValue
                case 4: widgetBackground5 = newValue
                case 5: widgetBackground6 = newValue
                case 6: widgetBackground7 = newValue
                case 7: widgetBackground8 = newValue
                default: break
                }
            }
        )
    }
    
    // MARK: - Selected Background Binding
    private var selectedFontColorBinding: Binding<Color> {
        Binding(
            get: {
                switch selectedIndex {
                case 0: return fontColor1
                case 1: return fontColor2
                case 2: return fontColor3
                case 3: return fontColor4
                case 4: return fontColor5
                case 5: return fontColor6
                case 6: return fontColor7
                case 7: return fontColor8
                default: return fontColor1
                }
            },
            set: { newValue in
                switch selectedIndex {
                case 0: fontColor1 = newValue
                case 1: fontColor2 = newValue
                case 2: fontColor3 = newValue
                case 3: fontColor4 = newValue
                case 4: fontColor5 = newValue
                case 5: fontColor6 = newValue
                case 6: fontColor7 = newValue
                case 7: fontColor8 = newValue
                default: break
                }
            }
        )
    }
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                Color("backgroundColor")
                    .ignoresSafeArea()
                           
                VStack {
                    ScrollView(.vertical) {
                        
                        ZStack {
                            DateTimeViewType1(height: 90.0)
                                .padding(.horizontal, 50)
                                .padding(.vertical, 25)
                                .background(widgetBackground1)
                                .foregroundColor(fontColor1)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(isSelected(viewName: "DateTimeViewType1"), lineWidth: 2)
                                }
                                .onTapGesture {
                                    doOnTap(theme: "DateTimeViewType1")
                                }
                                .padding()
                                .overlay(alignment: .topLeading) {
                                    cornerButton(image: "undo")
                                        .offset(x: 10, y: 10)
                                        .onTapGesture {
                                            //selectedIndex = 0
                                            //selectedTheme = "DateTimeViewType5"
                                            reset(index: 0, theme: "DateTimeViewType1")
                                        }
                                }
                                .overlay(alignment: .topTrailing) {
                                    cornerButton(image: "color-palette")
                                        .offset(x: -10, y: 10)
                                        .onTapGesture {
                                            selectedIndex = 0
                                            selectedTheme = "DateTimeViewType1"
                                            doOnTap(theme: selectedTheme)
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                showModal = true
                                            }
                                        }
                                }
                        }
                        
                        ZStack {
                            DateTimeViewType2()
                                .padding(.horizontal, 50)
                                .padding(.vertical, 25)
                                .background(widgetBackground2)
                                .foregroundColor(fontColor2)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(isSelected(viewName: "DateTimeViewType2"), lineWidth: 2)
                                }
                                .onTapGesture {
                                    doOnTap(theme: "DateTimeViewType2")
                                }
                                .padding()
                                .overlay(alignment: .topLeading) {
                                    cornerButton(image: "undo")
                                        .offset(x: 10, y: 10)
                                        .onTapGesture {
                                            reset(index: 1, theme: "DateTimeViewType2")
                                        }
                                }
                                .overlay(alignment: .topTrailing) {
                                    cornerButton(image: "color-palette")
                                        .offset(x: -10, y: 10)
                                        .onTapGesture {
                                            selectedIndex = 1
                                            selectedTheme = "DateTimeViewType2"
                                            doOnTap(theme: selectedTheme)
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                showModal = true
                                            }
                                        }
                                }
                        }
                        
                        ZStack {
                            DateTimeViewType3()
                                .padding(.horizontal, 40)
                                .padding(.vertical, 25)
                                .background(widgetBackground3)
                                .foregroundColor(fontColor3)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(isSelected(viewName: "DateTimeViewType3"), lineWidth: 2)
                                }
                                .onTapGesture {
                                    doOnTap(theme: "DateTimeViewType3")
                                }
                                .padding()
                                .overlay(alignment: .topLeading) {
                                    cornerButton(image: "undo")
                                        .offset(x: 10, y: 10)
                                        .onTapGesture {
                                            reset(index: 2, theme: "DateTimeViewType3")
                                        }
                                }
                                .overlay(alignment: .topTrailing) {
                                    cornerButton(image: "color-palette")
                                        .offset(x: -10, y: 10)
                                        .onTapGesture {
                                            selectedIndex = 2
                                            selectedTheme = "DateTimeViewType3"
                                            doOnTap(theme: selectedTheme)
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                showModal = true
                                            }
                                        }
                                }
                        }
                        
                        ZStack {
                            DateTimeViewType4()
                                .padding(.horizontal, 50)
                                .padding(.vertical, 25)
                                .background(widgetBackground4)
                                .foregroundColor(fontColor4)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(isSelected(viewName: "DateTimeViewType4"), lineWidth: 2)
                                }
                                .onTapGesture {
                                    doOnTap(theme: "DateTimeViewType4")
                                }
                                .padding()
                            
                            .overlay(alignment: .topLeading) {
                                cornerButton(image: "undo")
                                    .offset(x: 10, y: 10)
                                    .onTapGesture {
                                        reset(index: 3, theme: "DateTimeViewType4")
                                    }
                            }
                            
                            .overlay(alignment: .topTrailing) {
                                cornerButton(image: "color-palette")
                                    .offset(x: -10, y: 10)
                                    .onTapGesture {
                                        selectedIndex = 3
                                        selectedTheme = "DateTimeViewType4"
                                        doOnTap(theme: selectedTheme)
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showModal = true
                                        }
                                    }
                            }
                        }
                        
                        ZStack {
                            DateTimeViewType5()
                                .padding(.horizontal, 50)
                                .padding(.vertical, 25)
                                .background(widgetBackground5)
                                .foregroundColor(fontColor5)
                                .clipShape(RoundedRectangle(cornerRadius: 25))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(isSelected(viewName: "DateTimeViewType5"), lineWidth: 2)
                                }
                                .onTapGesture {
                                    doOnTap(theme: "DateTimeViewType5")
                                }
                                .padding()
                            
                            .overlay(alignment: .topLeading) {
                                cornerButton(image: "undo")
                                    .offset(x: 10, y: 10)
                                    .onTapGesture {
                                        reset(index: 4, theme: "DateTimeViewType5")
                                    }
                            }
                            
                            .overlay(alignment: .topTrailing) {
                                cornerButton(image: "color-palette")
                                    .offset(x: -10, y: 10)
                                    .onTapGesture {
                                        selectedIndex = 4
                                        selectedTheme = "DateTimeViewType5"
                                        doOnTap(theme: selectedTheme)
                                        withAnimation(.easeOut(duration: 0.3)) {
                                            showModal = true
                                        }
                                    }
                            }
                        }
                        
                        ZStack(alignment: .topTrailing) {
                            DateTimeViewType6()
                                .padding(.horizontal, 50)
                                .padding(.vertical, 25)
                                .background(widgetBackground6)
                                .foregroundColor(fontColor6)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 25.0)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(isSelected(viewName: "DateTimeViewType6"), lineWidth: 2.0)
                                }
                                .onTapGesture {
                                    doOnTap(theme: "DateTimeViewType6")
                                }
                                .padding()
                            
                                .overlay(alignment: .topLeading) {
                                    cornerButton(image: "undo")
                                        .offset(x: 10, y: 10)
                                        .onTapGesture {
                                            reset(index: 5, theme: "DateTimeViewType6")
                                        }
                                }
                                
                                .overlay(alignment: .topTrailing) {
                                    cornerButton(image: "color-palette")
                                        .offset(x: -10, y: 10)
                                        .onTapGesture {
                                            selectedIndex = 5
                                            selectedTheme = "DateTimeViewType6"
                                            doOnTap(theme: selectedTheme)
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                showModal = true
                                            }
                                        }
                                }
                        }
                        
                        ZStack(alignment: .topTrailing)  {
                            DateTimeViewType7()
                                .padding(.horizontal, 25)
                                .padding(.vertical, 25)
                                .background(widgetBackground7)
                                .foregroundColor(fontColor7)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 25.0)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(isSelected(viewName: "DateTimeViewType7"), lineWidth: 2.0)
                                }
                                .onTapGesture {
                                    //selectedTheme = "DateTimeViewType7"
                                    doOnTap(theme: "DateTimeViewType7")
                                }
                                .padding()
                            
                                .overlay(alignment: .topLeading) {
                                    cornerButton(image: "undo")
                                        .offset(x: 10, y: 10)
                                        .onTapGesture {
                                            reset(index: 6, theme: "DateTimeViewType7")
                                        }
                                }
                                
                                .overlay(alignment: .topTrailing) {
                                    cornerButton(image: "color-palette")
                                        .offset(x: -10, y: 10)
                                        .onTapGesture {
                                            selectedIndex = 6
                                            selectedTheme = "DateTimeViewType7"
                                            doOnTap(theme: selectedTheme)
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                showModal = true
                                            }
                                        }
                                }
                        }
                        
                        ZStack(alignment: .topTrailing) {
                            DateTimeViewType8()
                                .padding(.horizontal, 50)
                                .padding(.vertical, 25)
                                .background(widgetBackground8)
                                .foregroundColor(fontColor8)
                                .clipShape(
                                    RoundedRectangle(cornerRadius: 25.0)
                                )
                                .overlay {
                                    RoundedRectangle(cornerRadius: 25.0)
                                        .stroke(isSelected(viewName: "DateTimeViewType8"), lineWidth: 2.0)
                                }
                                .onTapGesture {
                                    doOnTap(theme: "DateTimeViewType8")
                                }
                                .padding()
                            
                                .overlay(alignment: .topLeading) {
                                    cornerButton(image: "undo")
                                        .offset(x: 10, y: 10)
                                        .onTapGesture {
                                            reset(index: 7, theme: "DateTimeViewType8")
                                        }
                                }
                                
                                .overlay(alignment: .topTrailing) {
                                    cornerButton(image: "color-palette")
                                        .offset(x: -10, y: 10)
                                        .onTapGesture {
                                            selectedIndex = 7
                                            selectedTheme = "DateTimeViewType8"
                                            doOnTap(theme: selectedTheme)
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                showModal = true
                                            }
                                        }
                                }
                        }
                        .padding([.leading, .trailing], 30)
                    }
                }
                .padding(.top, 20)
                
                if showModal {
                    // Dimmed background
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)

                    // Bottom modal
                    ScrollView(showsIndicators: false) {
                        VStack {
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
                                            
                                            ColorPicker("", selection: selectedFontColorBinding, supportsOpacity: false)
                                                .labelsHidden()
                                                .frame(width: 40, height: 40)
                                                .opacity(0.02) // invisible but tappable
                                        }
                                        
                                        ForEach(fontColorList, id: \.self) { color in
                                            
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(color)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(
                                                            isSelected(
                                                                value1: selectedFontColorBinding.wrappedValue.toHex() ?? "",
                                                                value2: color.toHex() ?? ""
                                                            ),
                                                            lineWidth: 2
                                                        )
                                                )
                                                .frame(width: 40, height: 40)
                                                .onTapGesture {
                                                    selectedFontColorBinding.wrappedValue = color
                                                }
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                }
                                .onChange(of: selectedFontColorBinding.wrappedValue) { _, newValue in
                                    guard let hex = newValue.toHex() else { return }
                                    viewModel.dateConfig.arr[selectedIndex].fontColor = hex
                                    doOnTap(theme: selectedTheme)
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
                                                            isSelected(value1: selectedFontColorBinding.wrappedValue.toHex() ?? "", value2: hex.toHex() ?? "" ),
                                                            lineWidth: 2
                                                        )
                                                )
                                                .frame(width: 40, height: 40)
                                                .onTapGesture { selectedFontColorBinding.wrappedValue = hex }
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                }
                                .onChange(of: selectedFontColorBinding.wrappedValue) { _, newValue in
                                    guard let hex = newValue.toHex() else { return }
                                    viewModel.dateConfig.arr[selectedIndex].fontColor = hex
                                    doOnTap(theme: selectedTheme)
                                }
                            }
                            
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
                                            
                                            ColorPicker("", selection: selectedBackgroundBinding, supportsOpacity: false)
                                                .labelsHidden()
                                                .frame(width: 40, height: 40)
                                                .opacity(0.02) // invisible but tappable
                                        }
                                        
                                        ForEach(backgroundColorList, id: \.self) { color in
                                            
                                            RoundedRectangle(cornerRadius: 16)
                                                .fill(color)
                                                .overlay(
                                                    RoundedRectangle(cornerRadius: 16)
                                                        .stroke(
                                                            isSelected(
                                                                value1: selectedBackgroundBinding.wrappedValue.toHex() ?? "",
                                                                value2: color.toHex() ?? ""
                                                            ),
                                                            lineWidth: 2
                                                        )
                                                )
                                                .frame(width: 40, height: 40)
                                                .onTapGesture {
                                                    selectedBackgroundBinding.wrappedValue = color
                                                }
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                }
                                .onChange(of: selectedBackgroundBinding.wrappedValue) { _, newValue in
                                    guard let hex = newValue.toHex() else { return }
                                    viewModel.dateConfig.arr[selectedIndex].backgroundColor = hex
                                    doOnTap(theme: selectedTheme)
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
                                                            isSelected(value1: selectedBackgroundBinding.wrappedValue.toHex() ?? "", value2: hex.toHex() ?? "" ) ,
                                                            lineWidth: 2
                                                        )
                                                )
                                                .frame(width: 40, height: 40)
                                                .onTapGesture { selectedBackgroundBinding.wrappedValue = hex }
                                        }
                                    }
                                    .padding(.horizontal, 14)
                                }
                                .onChange(of: selectedBackgroundBinding.wrappedValue) { _, newValue in
                                    guard let hex = newValue.toHex() else { return }
                                    viewModel.dateConfig.arr[selectedIndex].backgroundColor = hex
                                    doOnTap(theme: selectedTheme)
                                }
                            }
                        }
                        .padding()
//                        .padding()
//                        .frame(height: modalHeight)
//                        .frame(maxWidth: .infinity)
//                        .background(Color.white)
//                        .cornerRadius(10)
//                        .offset(y: dragOffset)
//                        .gesture(
//                            DragGesture()
//                                .onChanged { value in
//                                    if value.translation.height > 0 {
//                                        dragOffset = value.translation.height
//                                    }
//                                }
//                                .onEnded { value in
//                                    if value.translation.height > modalHeight * 0.25 {
//                                        withAnimation(.easeInOut(duration: 0.25)) {
//                                            dragOffset = modalHeight
//                                        }
//                                        
//                                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
//                                            showModal = false
//                                            dragOffset = 0
//                                        }
//                                    } else {
//                                        withAnimation(.spring()) {
//                                            dragOffset = 0
//                                        }
//                                    }
//                                }
//                            
//                        )
//                        .frame(maxHeight: .infinity, alignment: .bottom)
//                        .transition(.move(edge: .bottom))
//                        .ignoresSafeArea()
                    }
                    
                    .frame(height: modalHeight)
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(10)
                    .offset(y: dragOffset)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.height > 0 {
                                    dragOffset = value.translation.height
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > modalHeight * 0.25 {
                                    withAnimation(.easeInOut(duration: 0.25)) {
                                        dragOffset = modalHeight
                                    }
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                        showModal = false
                                        dragOffset = 0
                                    }
                                } else {
                                    withAnimation(.spring()) {
                                        dragOffset = 0
                                    }
                                }
                            }
                        
                    )
                    .frame(maxHeight: .infinity, alignment: .bottom)
                    .transition(.move(edge: .bottom))
                    .ignoresSafeArea()
                }
                
                
                if shouldShowProgressView {
                    ZStack {
                        Color.black.opacity(0.1) // Dim background
                            .ignoresSafeArea()

                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(1.5)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Image(systemName: "xmark")
                        .font(.system(size: 16, weight: .semibold))
                        .onTapGesture {
                            dismiss()
                        }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        Settings()
                    }) {
                        Image("SettingsNew")
                            .renderingMode(.template)
                            .foregroundColor(Color("textColor"))
                    }
                }
            }
            .onAppear {
                selectedTheme = viewModel.getSelectedThemeForTopWidget()
            }
        }
    }
    
    private func isSelected(viewName: String) -> Color {
        selectedTheme == viewName ? .gray : .clear
    }
    
    private func showProgressView() {
        shouldShowProgressView = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
            self.shouldShowProgressView = false
        }
    }
    
    private func doOnTap(theme: String) {
        viewModel.setTopWidget(theme: theme)
        selectedTheme = theme
        //showProgressView()
    }
    
    private func reset(index: Int, theme: String) {
        
        selectedTheme = theme
        selectedIndex = index
        
        selectedBackgroundBinding.wrappedValue = Color(hex: "#FFFFFF")
        selectedFontColorBinding.wrappedValue = Color(hex: "#000000")
        
        viewModel.dateConfig.arr[index].backgroundColor = "#FFFFFF"
        viewModel.dateConfig.arr[index].fontColor = "#000000"
        
        viewModel.setTopWidget(theme: theme)
        showProgressView()
    }
    
    func cornerButton(image: String) -> some View {
        Image(image)
            .resizable()
            .scaledToFit()
            .frame(width: 20, height: 20)
            .padding(8)
            .background(Color.white)
            .clipShape(Circle())
            .shadow(color: .black.opacity(0.2), radius: 4, y: 2)
    }
}

private extension WidgetList {
    func isSelected(value1: String, value2: String) -> Color {
        value1 == value2 ? .blue : .clear
    }
    
    func isSelectedAlignment(value1: String, value2: String) -> Color {
        value1 == value2 ? .blue : .clear
    }
    
}

#Preview {
    WidgetList()
}
