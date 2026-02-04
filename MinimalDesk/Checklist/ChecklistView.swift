//
//  ChecklistView.swift
//  MinimalDesk
//
//  Created by Haider on 6/12/25.
//

import SwiftUI
import Siren

struct ChecklistView: View {
   @Environment(\.requestReview) var requestReview
   @AppStorage("subscribed") private var subscribed = false
   @AppStorage("showRatingView") private var showRatingView = true
   @StateObject var subViewModel = SubscriptionViewModel()
   @State var widthToSet: CGFloat = 0
   @State var heightToSet: CGFloat = 0
   @State var gap: CGFloat = 0
   @State private var isDetailViewVisible = false
   @State private var isCustomAppViewVisible = false
   @State private var presentSubscriptionView = false
   @State private var showAppListView = false
   @State private var currentCardIndex: Int? = 0
   @State private var showLimitCrossed = false
   @ObservedObject private var viewModel = ChecklistViewModel.shared
   //@ObservedObject private var widgetVM = WidgetViewModel.shared
    
   @ObservedObject private var widgetVM = WidgetViewModel.shared
   @State private var presentSubscriptionViewForCustom = false
   @State private var isWidgetListPresented = false
   @State private var isPresented = false
   private let cardsLimit: Int = 5 // TODO: Change later
   @State private var settingsDetent = PresentationDetent.medium
    
    // TODO
    @State private var isPresentedTodoInput = false

   var body: some View {
       GeometryReader { geo in
           ZStack {

               Color("backgroundColor")
                   .ignoresSafeArea()
 
               VStack(spacing: 0) {
                   // MARK: - AppList Widget Demo
                   VStack {
                       ScrollView(.horizontal, showsIndicators: false) {
                           HStack(spacing: 0) {
                               ForEach(0...viewModel.cards, id: \.self) { index in
                                   CardView(for: index, geo: geo)
                                       //.frame(width: UIScreen.main.bounds.width)
                                       .onTapGesture {
                                           if index < viewModel.cards {
                                               currentCardIndex = index
                                               //showAppListView = true
                                           } else if viewModel.cards >= cardsLimit {
                                               Task {
                                                   await handleLimitCrossed()
                                               }
                                           } else {
                                               currentCardIndex = viewModel.cards
                                               isPresentedTodoInput = true
                                               //showAppListView = true
                                           }
                                       }
                               }
                           }

                       }
                       .ignoresSafeArea()
                       .scrollTargetLayout()
                       .scrollBounceBehavior(.basedOnSize)
                       .scrollTargetBehavior(.viewAligned)
                       .scrollPosition(id: $currentCardIndex)
                       .padding(.top, 8)
                       
                       Text("Swipe left or right to explore more pages")
                           .font(.system(size: 14, weight: .medium, design: .default))
                           .foregroundColor(Color(hex: "#A0A0A0"))
                   }

                   Spacer()
                   
                   VStack(spacing: 3) {
                       
                       // Top Widgets Button (Unrestricted)

                       Text("Checklists")
                           .font(.system(size: 15))
                           .fontWeight(.semibold)
                           .padding([.top, .bottom], 10)
                           .foregroundColor(Color("WidgetsTitle"))
                           .frame(width: screenWidth * 0.92, alignment: .leading)
                       
                       // Customize Widget Button (Restricted)
                       HStack(spacing: 10) {
                           Image("Todo") // Todo
                           
                           VStack(alignment: .leading, spacing: 2) {
                               Text("Todo")
                                   //.font(.headline)
                                   .font(.system(size: 16))
                                   .fontWeight(.semibold)
                                   .foregroundColor(Color("textColor"))

                               Text("Organize tasks easily and stay focused")
                                   .font(.system(size: 11))
                                   //foregroundColor(Color.black)
                                   .foregroundColor(Color(red: 157/255, green: 157/255, blue: 164/255))
                           }
                           
                           Spacer()
                           
                           Button(action: {
                               isPresentedTodoInput = true
//                               if Store.shared.userHasActivePurchase() {
//                                   isPresented = true
//                               } else {
//                                   presentSubscriptionView = true
//                               }
                           }) {
                             Text("Edit")
                                .font(.system(size: 14))
                                .foregroundColor(Color("textColor"))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 24)
                                .background(Color("buttonColor"))
                                .cornerRadius(10)
                                
                           }
//                           .sheet(isPresented: $isPresented) {
//                               ChecklistInputView()
//                                   //.presentationDetents([.fraction(0.45)])
//                           }

                       }
                       .padding([.leading, .trailing], 13)
                       //.frame(width: screenWidth * 0.92, height: screenHeight * 0.08)
                       .frame(width: geo.size.width * 0.92, height: geo.size.height * 0.09)
                       .background(Color("whiteColor"))
                       .cornerRadius(18)
                       
                       
                       

                       // 2nd button
                       Text("Styles")
                           .font(.system(size: 15))
                           .fontWeight(.semibold)
                           .padding([.top, .bottom], 10)
                           .foregroundColor(Color("WidgetsTitle"))
                           .frame(width: screenWidth * 0.92, alignment: .leading)
                       
                       // Customize Widget Button (Restricted)
                       HStack(spacing: 10) {
                           Image("Features") // Todo
                           
                           VStack(alignment: .leading, spacing: 2) {
                               Text("Customize Widgets")
                                   //.font(.headline)
                                   .font(.system(size: 16))
                                   .fontWeight(.semibold)
                                   .foregroundColor(Color("textColor"))

                               Text("Standard layout with full details")
                                   .font(.system(size: 11))
                                   //foregroundColor(Color.black)
                                   .foregroundColor(Color(red: 157/255, green: 157/255, blue: 164/255))
                           }
                           
                           Spacer()
                           
                           Button(action: {
                               if Store.shared.userHasActivePurchase() {
                                   isPresented = true
                               } else {
                                   presentSubscriptionView = true
                               }
                           }) {
                             Text("Edit")
                                .font(.system(size: 14))
                                .foregroundColor(Color("textColor"))
                                .padding(.vertical, 10)
                                .padding(.horizontal, 24)
                                .background(Color("buttonColor"))
                                .cornerRadius(10)
                                
                           }
                           .sheet(isPresented: $isPresented) {
                               CustomWidget()
                                   .presentationDetents([.fraction(0.45)])
                           }

                       }
                       .padding([.leading, .trailing], 13)
                       //.frame(width: screenWidth * 0.92, height: screenHeight * 0.08)
                       .frame(width: geo.size.width * 0.92, height: geo.size.height * 0.09)
                       .background(Color("whiteColor"))
                       .cornerRadius(18)
                       //.padding([.leading, .trailing], 24)
                       

                   }
                   .padding(.bottom, 80)

               }
               if showLimitCrossed {
                   ToastView(message: "Maximum of \(cardsLimit) todo list can be added")
               }
           }
           .toolbar {
               ToolbarItem(placement: .navigationBarLeading) {
                   Text("Less Phone")
                       .fontWeight(.bold)
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
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                       self.setupSiren()
                   }
               widthToSet = (screenWidth * 0.85) / 2.0
               gap = (screenWidth - widthToSet * 2) / 3.0
               heightToSet = (112 * widthToSet) / 176.0

               Task {
                   await subViewModel.updateCustomerProductStatus()
                   await MainActor.run {
                       self.getValue()
                       presentSubscriptionView = !subscribed
                   }
               }

               setInitialFavApps()
               // Optional: Sync AppStorage with actual purchase status
               subscribed = Store.shared.userHasActivePurchase()
           }
           .fullScreenCover(isPresented: $presentSubscriptionView) {
               // need to understand // farjum
               SubscriptionView()
           }
           .fullScreenCover(isPresented: $showAppListView) {
               AppListView(viewModel: FirebaseDataViewModel.shared, cardIndex: currentCardIndex ?? 0)
           }
           .sheet(isPresented: $isPresentedTodoInput) {
               NavigationStack {
                   ChecklistInputView(viewModel: viewModel, cardIndex: currentCardIndex ?? 0)
               }
                   //.presentationDetents([.fraction(0.45)])
           }
       }
       

   }

   func setupSiren() {
       print("irbaz vhai")
       let siren = Siren.shared
      
       siren.rulesManager = RulesManager(globalRules: Rules(promptFrequency: .immediately, forAlertType: .option))
       siren.wail()
   }
   
   func getValue() {
       let value = Store.shared.userHasActivePurchase()
       print("i have found \(value)")
       subscribed = value
   }

   private func setInitialFavApps() {
//       let initialFavApps = UserDefaults.standard.value(forKey: UserDefaultsKeys.initallySelectedFavApps.rawValue) as? [String] ?? []
//       if !initialFavApps.isEmpty {
//           let convertedDictionary = initialFavApps.map { appName in
//               guard let appIndex = viewModel.appList.firstIndex(where: { app in
//                   app.appName == appName
//               }) else {
//                   return [String: String]()
//               }
//               let app = viewModel.appList[appIndex]
//               return ["name": app.appName, "link": app.appLink, "rank": "\(app.appRank)"]
//           }
//           viewModel.setInitialFavApps(initalFavApps: convertedDictionary)
//       }
   }

   @ViewBuilder
   private func CardView(for index: Int, geo: GeometryProxy) -> some View {
       
       let frameAlignment = Alignment(
           horizontal: widgetVM.alignmentPair.0,
           vertical: widgetVM.alignmentPair.1
       )
       
       ZStack(alignment: .bottomTrailing) {
           //VStack(alignment: .leading, spacing: 0) {
           VStack{
               if index == viewModel.cards {
                   Image(systemName: "plus")
                       .resizable()
                       .scaledToFit()
                       .frame(width: 30, height: 30)
                       .foregroundColor(.white)
               } else {
                   VStack(spacing: widgetVM.favAppWidgetConfig.spacing) {
                       //ForEach($selectedItems.indices, id: \.self) { index in
                       ForEach(viewModel.todoListView[index].indices, id: \.self) { itemIndex in
                           let todo = viewModel.todoListView[index][itemIndex]
                           
                           Text(todo.title)
                               .strikethrough(todo.isCompleted)
                               .foregroundColor(Color(hex: widgetVM.favAppWidgetConfig.fontColor))
                               .opacity(todo.isCompleted ? 0.4 : 1)
                               .textCase(widgetVM.favAppWidgetConfig.caseText == "default" ? nil : .uppercase)
                               .font(.system(
                                
                                    size: widgetVM.favAppWidgetConfig.fontSize,
                                    weight: CustomWidget.FontWeightConverter(weightString:widgetVM.favAppWidgetConfig.fontWeight).value,
                                    design: CustomWidget.FontTypeConverter(FontString: widgetVM.favAppWidgetConfig.fontType).value
                               
                               ))

                               .frame(maxWidth: .infinity, alignment: frameAlignment)
                               .listRowBackground(Color.clear)
                               .background(Color(hex: widgetVM.favAppWidgetConfig.backgroundColor))
                               .onTapGesture {
                                   viewModel.toggleCompletion(index: index, itemIndex: itemIndex)
                               }
                       }
                       .onMove { indices, newOffset in
                           //moveItems(at: indices, to: newOffset, in: index)
                       }
                   }
                   .listStyle(.plain)
                   .padding(15)
                   .scrollContentBackground(.hidden)
                   .frame(
                       maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: frameAlignment
                   )
                   
               }
           }
           .background(index == viewModel.cards ? Color.clear : Color(hex: widgetVM.favAppWidgetConfig.backgroundColor))
           //.font(Font.custom( widgetVM.favAppWidgetConfig.fontType, size: 50))
           .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.45)
           .background(index == viewModel.cards ? Color.gray.opacity(0.3) : Color.clear)
           .clipShape(RoundedRectangle(cornerRadius: 30))
//           .overlay(
//               RoundedRectangle(cornerRadius: 30)
//           )
           .padding()
           if index < viewModel.cards {
               // delete the card // farjum
               Image(systemName: "trash.circle")
                   .resizable()
                   .scaledToFit()
                   .frame(width: 28, height: 28)
                   .foregroundStyle(Color(red: 160/255, green: 160/255, blue: 160/255))
                   //.foregroundColor(Color(red: 160/255, green: 160/255, blue: 160/255))
                   .padding(35)
                   .onTapGesture {
                       viewModel.setTodoDeleteCard(cardIndex: index)
                   }
           }
       }
   }

   // MARK: - Helper Method
//   private func moveItems(at indices: IndexSet, to newOffset: Int, in index: Int) {
//       guard index < viewModel.appsOnAddView.count else { return }
//       viewModel.appsOnAddView[index].move(fromOffsets: indices, toOffset: newOffset)
//       viewModel.setFavAppsOnReorder(index: index)
//   }

   // add new card
   private func addCardButton() -> some View {
       Button(action: {
           if viewModel.cards < cardsLimit {
               currentCardIndex = viewModel.cards
               showAppListView = true
           } else {
               Task {
                   await handleLimitCrossed()
               }
           }
       }) {
           Image(systemName: "plus")
               .resizable()
               .scaledToFit()
               .frame(width: 20, height: 20)
               .padding(5)
               .foregroundColor(.white)
               .clipShape(Circle())
               .overlay(
                   Circle()
                       .stroke(Color.white, lineWidth: 1)
               )
       }
   }

   private func handleLimitCrossed() async {
       showLimitCrossed = true
       DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
           showLimitCrossed = false
       }
   }
}


#Preview {
    ChecklistView()
}
