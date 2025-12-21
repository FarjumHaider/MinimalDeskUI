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
    
    @State private var isPresented = false
    
    @State var widgetBackground1: Color
    @State var widgetBackground2: Color
    @State var widgetBackground3: Color
    @State var widgetBackground4: Color
    
    @State var fontColor1: Color
    @State var fontColor2: Color
    @State var fontColor3: Color
    @State var fontColor4: Color
    
    @State private var showModal = false
    private let modalHeight = UIScreen.main.bounds.height / 4
    @State private var dragOffset: CGFloat = 0
//
//    @State var widgetBackground2: Color
    
    //private let viewModel1 = WidgetViewModel.shared
    
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
    
    
    init() {
        //self.widgetConfig = viewModel.dateConfig.arr
        self.widgetBackground1 = Color(hex: viewModel.dateConfig.arr[0].backgroundColor)
        self.widgetBackground2 = Color(hex: viewModel.dateConfig.arr[1].backgroundColor)
        self.widgetBackground3 = Color(hex: viewModel.dateConfig.arr[2].backgroundColor)
        self.widgetBackground4 = Color(hex: viewModel.dateConfig.arr[3].backgroundColor)
        
        self.fontColor1 = Color(hex: viewModel.dateConfig.arr[0].fontColor)
        self.fontColor2 = Color(hex: viewModel.dateConfig.arr[1].fontColor)
        self.fontColor3 = Color(hex: viewModel.dateConfig.arr[2].fontColor)
        self.fontColor4 = Color(hex: viewModel.dateConfig.arr[3].fontColor)
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
                default: return widgetBackground1
                }
            },
            set: { newValue in
                switch selectedIndex {
                case 0: widgetBackground1 = newValue
                case 1: widgetBackground2 = newValue
                case 2: widgetBackground3 = newValue
                case 3: widgetBackground4 = newValue
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
                default: return fontColor1
                }
            },
            set: { newValue in
                switch selectedIndex {
                case 0: fontColor1 = newValue
                case 1: fontColor2 = newValue
                case 2: fontColor3 = newValue
                case 3: fontColor4 = newValue
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
                            DateTimeViewType5()
                                .padding(.horizontal, 50)
                                .padding(.vertical, 25)
                                .background(widgetBackground1)
                                .foregroundColor(fontColor1)
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
                                        //selectedIndex = 0
                                        //selectedTheme = "DateTimeViewType5"
                                        reset(index: 0, theme: "DateTimeViewType5")
                                    }
                            }
                            
                            .overlay(alignment: .topTrailing) {
                                cornerButton(image: "color-palette")
                                    .offset(x: -10, y: 10)
                                    .onTapGesture {
                                        selectedIndex = 0
                                        selectedTheme = "DateTimeViewType5"
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
                                .background(widgetBackground2)
                                .foregroundColor(fontColor2)
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
                                            reset(index: 1, theme: "DateTimeViewType7")
                                        }
                                }
                                
                                .overlay(alignment: .topTrailing) {
                                    cornerButton(image: "color-palette")
                                        .offset(x: -10, y: 10)
                                        .onTapGesture {
                                            selectedIndex = 1
                                            isPresented = true
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
                                .background(widgetBackground3)
                                .foregroundColor(fontColor3)
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
                                            reset(index: 2, theme: "DateTimeViewType8")
                                        }
                                }
                                
                                .overlay(alignment: .topTrailing) {
                                    cornerButton(image: "color-palette")
                                        .offset(x: -10, y: 10)
                                        .onTapGesture {
                                            selectedIndex = 2
                                            isPresented = true
                                            selectedTheme = "DateTimeViewType8"
                                            doOnTap(theme: selectedTheme)
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                showModal = true
                                            }
                                        }
                                }
                        }
                        .padding([.leading, .trailing], 30)
                        
                        ZStack(alignment: .topTrailing) {
                            DateTimeViewType6()
                                .padding(.horizontal, 50)
                                .padding(.vertical, 25)
                                .background(widgetBackground4)
                                .foregroundColor(fontColor4)
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
                                            reset(index: 3, theme: "DateTimeViewType6")
                                        }
                                }
                                
                                .overlay(alignment: .topTrailing) {
                                    cornerButton(image: "color-palette")
                                        .offset(x: -10, y: 10)
                                        .onTapGesture {
                                            selectedIndex = 3
                                            isPresented = true
                                            selectedTheme = "DateTimeViewType6"
                                            doOnTap(theme: selectedTheme)
                                            withAnimation(.easeOut(duration: 0.3)) {
                                                showModal = true
                                            }
                                        }
                                }
                        }
                    }
                    

                    
                }
                .padding(.top, 20)
                
                if showModal {
                    // Dimmed background
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .transition(.opacity)


                    // Bottom modal
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
                    }
                    .padding()
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
                    }
                }
            }
            .onAppear {
                selectedTheme = viewModel.getSelectedThemeForTopWidget()
//                self.widgetBackground1 = Color(hex: viewModel.dateConfig.arr[0].backgroundColor)
//                self.widgetBackground2 = Color(hex: viewModel.dateConfig.arr[1].backgroundColor)
//                self.widgetBackground3 = Color(hex: viewModel.dateConfig.arr[2].backgroundColor)
//                self.widgetBackground4 = Color(hex: viewModel.dateConfig.arr[3].backgroundColor)
            }
        }

//        .onAppear {
//            selectedTheme = viewModel.getSelectedThemeForTopWidget()
//        }
    }
    
    private func isSelected(viewName: String) -> Color {
        selectedTheme == viewName ? .gray : Color(hex: "#EFEFEF")
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

//struct CustomColorView: View {
//    
//    let backgroundColorHexList1 = [
//        "#F4EADE",
//        "#FFDFE0",
//        "#E1EBEA",
//        "#D5EAEB",
//        "#F9DDB8",
//        "#F1F3CE",
//        "#DCE0CF",
//        "#EFEEEA",
//        "#EBDCB1",
//        "#C4DFE6",
//        "#FFE2D0",
//        "#E5DCDF",
//        "#000000",
//    ]
//    
//    var backgroundColorList1: [Color] {
//        backgroundColorHexList1.compactMap { Color(hex: $0) }
//    }
//    
////    @Binding var widgetConfig: [FavAppWidgetConfig1]
////    @Binding var selectedIndex: Int
//    
//    @State var selectedTheme: String
////    @State var widgetBackground: Color
////    @State var fontColor: Color
//    
//    @State var widgetBackground1: Color
//    @State var widgetBackground2: Color
//    @State var index: Int
//    
//    @State private var shouldShowProgressView = false
////    @Binding var widgetBackground2: Color
//    
//    @StateObject private var viewModel = WidgetViewModel.shared
//    //private let viewModel = WidgetViewModel.shared
//    
//    init(index: Int, selectedTheme: String) {
//        //self.widgetConfig = viewModel.dateConfig.arr
//        //self.widgetBackground1 = Color(hex: viewModel1.favAppWidgetConfig1.backgroundColor)
//        widgetBackground1 = Color(hex: viewModel.dateConfig.arr[0].backgroundColor)
//        widgetBackground2 = Color(hex: viewModel.dateConfig.arr[1].backgroundColor)
//        self.index = index
//        self.selectedTheme = selectedTheme
//    }
//    
////    init(widgetBackground: Color, fontColor: Color, index: Int, selectedTheme: String, widgetBackground2: Binding<Color>) {
////        self.widgetBackground = widgetBackground
////        self.fontColor = fontColor
////        self.index = index
////        self.selectedTheme = selectedTheme
////        self._widgetBackground2 = widgetBackground2
////    }
//    
//    var body: some View {
//        
//        
//        ZStack{
//            VStack {
//                Text("Text Color")
//                    .foregroundColor(Color(hex: "#646464"))
//                    .font(.system(size: 16))
//                    .fontWeight(.semibold)
//                    .padding([.top, .bottom], 10)
//                    .frame(width: screenWidth * 0.92, alignment: .leading)
//                
//                ScrollView(.horizontal, showsIndicators: false) {
//                    HStack(spacing: 14) {
//                        
//                        ZStack {
//                            Image("palette")
//                                .resizable()
//                                .scaledToFill()
//                                .frame(width: 40, height: 40)
//                                .clipShape(RoundedRectangle(cornerRadius: 16))
//                                .allowsHitTesting(false)
//                            //.background(Color.red)
//                            
//                            Picker<Text, SelectionValue, <#Content: View#>>("Unit Picker", selection: $viewModel.unit)
//                                .labelsHidden()
//                                .frame(width: 40, height: 40)
//                                .opacity(0.02) // invisible but tappable
//                        }
//                        
//                        //                                ForEach(fontColorList, id: \.self) { hex in
//                        //
//                        //                                    //VStack {
//                        //                                    RoundedRectangle(cornerRadius: 16)
//                        //                                        .fill(Color(hex: hex.toHex()!))                      // Background color of circle
//                        //                                        .overlay(                               // Add border using overlay
//                        //                                            RoundedRectangle(cornerRadius: 16)
//                        //                                                .stroke(
//                        //                                                    isSelected(value1: widgetBackground1.toHex()!, value2: hex.toHex()! ) ,
//                        //                                                    // No border when not selected
//                        //                                                    lineWidth: 1
//                        //                                                )
//                        //                                        )
//                        //                                        .frame(width: 40, height: 40)
//                        //                                        .onTapGesture { widgetBackground1 = hex }
//                        //                                    ///}
//                        //
//                        //                                }
//                    }
//                    .padding(.horizontal, 14)
//                }
//                .onChange(of: widgetBackground2) { _, _ in
//                    guard let fontColorHex = widgetBackground2.toHex(),
//                          fontColorHex != viewModel.dateConfig.arr[index].backgroundColor else { return }
//                    
//                    viewModel.dateConfig.arr[index].backgroundColor = fontColorHex
//                    doOnTap(theme: selectedTheme)
//                    //isDoneButtonDisabled = false
//                }
//            }
//            
//            
//            
//            
//            //        VStack {
//            //            Text("Text Color")
//            //                .foregroundColor(Color(hex: "#646464"))
//            //                .font(.system(size: 16))
//            //                .fontWeight(.semibold)
//            //                .padding([.top, .bottom], 10)
//            //                .frame(width: screenWidth * 0.92, alignment: .leading)
//            //
//            //            ScrollView(.horizontal, showsIndicators: false) {
//            //                HStack(spacing: 14) {
//            //
//            //                    ZStack {
//            //                        Image("palette")
//            //                            .resizable()
//            //                            .scaledToFill()
//            //                            .frame(width: 40, height: 40)
//            //                            .clipShape(RoundedRectangle(cornerRadius: 16))
//            //                            .allowsHitTesting(false)
//            //
//            //                        ColorPicker("", selection: $widgetBackground2, supportsOpacity: false)
//            //                            .labelsHidden()
//            //                            .frame(width: 40, height: 40)
//            //                            .opacity(0.02) // invisible but tappable
//            //                            .onChange(of: widgetBackground2) { _, _ in
//            //                                print("Farjum in \(widgetBackground2)")
//            //                                guard let fontColorHex = widgetBackground2.toHex(),
//            //                                      fontColorHex != viewModel.dateConfig.arr[1].backgroundColor else { return }
//            //
//            //                                viewModel.dateConfig.arr[1].backgroundColor = fontColorHex
//            //                                print("Farjum out \(fontColorHex)")
//            //                                viewModel.setTopWidget(theme: selectedTheme)
//            //                                //isDoneButtonDisabled = false
//            //                            }
//            //                    }
//            //
//            ////
//            ////                    ForEach(backgroundColorList1, id: \.self) { hex in
//            ////
//            ////                        //VStack {
//            ////                        RoundedRectangle(cornerRadius: 16)
//            ////                            .fill(Color(hex: hex.toHex()!))                // Background color
//            ////                            .overlay(                               // Add border using overlay
//            ////                                RoundedRectangle(cornerRadius: 16)
//            ////                                    .stroke(
//            ////                                        isSelected(value1: widgetBackground2.toHex()!, value2: hex.toHex()! ) ,
//            ////                                        lineWidth: 1
//            ////                                    )
//            ////                            )
//            ////                            .frame(width: 40, height: 40)
//            ////                        //.cornerRadius(16)
//            ////                            .onTapGesture { widgetBackground2 = hex }
//            ////                        ///}
//            ////
//            ////                    }
//            //
//            //                }
//            //                .padding(.horizontal, 14)
//            //            }
//            //
//            ////            .onChange(of: widgetBackground2) { _, _ in
//            ////                print("Farjum in \(widgetBackground2)")
//            ////                guard let backgroundcolorHex = widgetBackground2.toHex(),
//            ////                      backgroundcolorHex != viewModel.dateConfig.arr[index].backgroundColor else { return }
//            ////
//            ////                viewModel.dateConfig.arr[index].backgroundColor = backgroundcolorHex
//            ////                print("Farjum out \(backgroundcolorHex)")
//            ////                viewModel.setTopWidget(theme: selectedTheme)
//            ////                //isDoneButtonDisabled = false
//            ////            }
//            //        }
//            
//            if shouldShowProgressView {
//                ZStack {
//                    Color.black.opacity(0.1) // Dim background
//                        .ignoresSafeArea()
//
//                    ProgressView()
//                        .progressViewStyle(.circular)
//                        .scaleEffect(1.5)
//                }
//            }
//        }
//        
//        
//    }
//    
//    private func doOnTap(theme: String) {
//        viewModel.setTopWidget(theme: theme)
//        selectedTheme = theme
//        showProgressView()
//    }
//    
//    private func showProgressView() {
//        shouldShowProgressView = true
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
//            self.shouldShowProgressView = false
//        }
//    }
//}
//
//private extension CustomColorView {
//    func isSelected(value1: String, value2: String) -> Color {
//        value1 == value2 ? .blue : .clear
//    }
//    
//    func isSelectedAlignment(value1: String, value2: String) -> Color {
//        value1 == value2 ? .blue : .clear
//    }
//    
//}

#Preview {
    WidgetList()
}
