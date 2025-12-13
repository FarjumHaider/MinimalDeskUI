

import SwiftUI
import Siren
///  working
struct AddView: View {
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
   @ObservedObject private var viewModel = FirebaseDataViewModel.shared
   //@ObservedObject private var widgetVM = WidgetViewModel.shared
    
   @ObservedObject private var widgetVM = WidgetViewModel.shared
   @State private var presentSubscriptionViewForCustom = false
   @State private var isWidgetListPresented = false
   @State private var isPresented = false
   private let cardsLimit: Int = 5 // TODO: Change later
   @State private var settingsDetent = PresentationDetent.medium

   var body: some View {
       GeometryReader { geo in
           ZStack {
               //Color.black.edgesIgnoringSafeArea(.all)
               Color("backgroundColor")
                   .ignoresSafeArea()
                   //.edgesIgnoringSafeArea(.all)
               
               VStack(spacing: 0) {
    //                Text("Less Phone")
    //                    .font(.largeTitle)
    //                    .bold()
    //                Spacer()

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
                                               showAppListView = true
                                           } else if viewModel.cards >= cardsLimit {
                                               Task {
                                                   await handleLimitCrossed()
                                               }
                                           } else {
                                               currentCardIndex = viewModel.cards
                                               showAppListView = true
                                           }
                                       }
                               }
                           }
                           //.padding(.leading, viewModel.cards <= 1 ? (screenWidth * 0.30) / 2.0 : 0)
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
                   //.frame(height: geo.size.height * 0.55)

    //                HStack(spacing: 0) {
    //                    Spacer()
    //                    addCardButton()
    //                }
    //                .frame(maxWidth: screenWidth * 0.9)
    //
    //                if !showRatingView { Spacer() }
    //
    //                // MARK: - Rating View
    //                if showRatingView {
    //                    HStack {
    //                        VStack(alignment: .leading) {
    //                            Text("We appreciate your feedback!")
    //                            Text("Leave a 5-star rating for LessPhone on the App Store.")
    //                                .multilineTextAlignment(.leading)
    //                                .fixedSize(horizontal: false, vertical: true)
    //                        }
    //                        .font(.system(size: 14))
    //                        Spacer()
    //                        Text("Rate Now")
    //                            .font(.system(size: 14))
    //                            .foregroundColor(.green)
    //                            .padding(.horizontal, 10)
    //                            .onTapGesture {
    //                                requestReview()
    //                                showRatingView = false
    //                            }
    //                    }
    //                    .frame(maxWidth: .infinity)
    //                    .padding(.vertical)
    //                    .padding(.horizontal, 10)
    //                    .clipShape(RoundedRectangle(cornerRadius: 10))
    //                    .overlay {
    //                        RoundedRectangle(cornerRadius: 10.0).stroke(.white, lineWidth: 1)
    //                    }
    //                    .padding()
    //                }

                   Spacer()
                   
                   VStack(spacing: 3) {
                       
                       // Top Widgets Button (Unrestricted)
                       Text("Top Widgets")
                           //.foregroundColor(Color.white)
                           .font(.system(size: 15))
                           .fontWeight(.semibold)
                           .padding([.top, .bottom], 10)
                           .foregroundColor(Color(red: 160/255, green: 160/255, blue: 160/255))
                           .frame(width: screenWidth * 0.92, alignment: .leading)
                       
                       Text("Choose Top Widgets")
                           .font(.system(size: 16))
                           .fontWeight(.semibold)
                           .foregroundColor(Color.black)
                           //.frame(width: screenWidth * 0.92, height: screenHeight * 0.08)
                           .frame(width: geo.size.width * 0.92, height: geo.size.height * 0.09)
                           .background(.white)
                           .cornerRadius(18)
                           .onTapGesture {
                               isWidgetListPresented = true
                           }
                           .fullScreenCover(isPresented: $isWidgetListPresented) {
                               WidgetList()
                           }
                           //.padding([.leading, .trailing], 13)

                       Text("Styles")
                           .font(.system(size: 15))
                           .fontWeight(.semibold)
                           .padding([.top, .bottom], 10)
                           .foregroundColor(Color(red: 160/255, green: 160/255, blue: 160/255))
                           .frame(width: screenWidth * 0.92, alignment: .leading)
                       
                       // Customize Widget Button (Restricted)
                       HStack(spacing: 10) {
                           Image("Features")
                           
                           VStack(alignment: .leading, spacing: 2) {
                               Text("Customize Widgets")
                                   //.font(.headline)
                                   .font(.system(size: 16))
                                   .fontWeight(.semibold)
                                   .foregroundColor(Color.black)

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
                                .foregroundColor(Color.black)
                                .padding(.vertical, 10)
                                .padding(.horizontal, 24)
                                .background(Color("backgroundColor"))
                                .cornerRadius(10)
                                
                           }
                           .sheet(isPresented: $isPresented) {
                               CustomWidget()
                                   .presentationDetents([.fraction(0.45)])
                                   //.presentationDetents([.medium])
                                   //.presentationDragIndicator(.visible)
//                                   .presentationDetents(
//                                       [.medium],
//                                       selection: $settingsDetent
//                                    )
                           }

                       }
                       .padding([.leading, .trailing], 13)
                       //.frame(width: screenWidth * 0.92, height: screenHeight * 0.08)
                       .frame(width: geo.size.width * 0.92, height: geo.size.height * 0.09)
                       .background(.white)
                       .cornerRadius(18)
                       //.padding([.leading, .trailing], 24)
                       

                   }
                   .padding(.bottom, 80)
                   
    //                // MARK: - Add Options
    //                HStack(spacing: gap) {
    //                    // MARK: - Add Apps from Given List
    //                    VStack(spacing: 8) {
    //                        Image("leftThumb")
    //                            .resizable()
    //                            .aspectRatio(contentMode: .fit)
    //                            .frame(width: 35, height: 35)
    //                        Text("Add Apps")
    //                            .font(.headline)
    //                            .foregroundColor(Color.white)
    //                        Text("Add remove or reorder apps")
    //                            .font(.system(size: 10))
    //                            .foregroundColor(Color(red: 175.0/255, green: 175.0/255, blue: 179.0/255))
    //                    }
    //                    .frame(width: widthToSet, height: heightToSet)
    //                    .background(Color(red: 41/255, green: 44/255, blue: 53/255))
    //                    .cornerRadius(10)
    //                    .onTapGesture {
    //                        self.isDetailViewVisible.toggle()
    //                    }
    //                    .fullScreenCover(isPresented: $isDetailViewVisible) {
    //                        AppListView(viewModel: FirebaseDataViewModel.shared)
    //                    }
    //
    //                    // MARK: - Add Custom Apps (with purchase restriction)
    //                    VStack(spacing: 8) {
    //                        Image("RightThumb")
    //                            .resizable()
    //                            .aspectRatio(contentMode: .fill)
    //                            .frame(width: 35, height: 35)
    //                        Text("Add Custom")
    //                            .font(.headline)
    //                            .foregroundColor(Color.white)
    //                        Text("Add apps by using URL Schemes")
    //                            .font(.system(size: 10))
    //                            .foregroundColor(Color(red: 175.0/255, green: 175.0/255, blue: 179.0/255))
    //                    }
    //                    .frame(width: widthToSet, height: heightToSet)
    //                    .background(Color(red: 41/255, green: 44/255, blue: 53/255))
    //                    .cornerRadius(10)
    //                    .onTapGesture {
    //                        Task {
    //                            await subViewModel.updateCustomerProductStatus()
    //                            await MainActor.run {
    //                                self.getValue()
    //                                subscribed = true // farjum
    //                                if subscribed {
    //                                    isCustomAppViewVisible = true
    //                                } else {
    //                                    presentSubscriptionViewForCustom = true
    //                                }
    //                            }
    //                        }
    //                    }
    //                    .fullScreenCover(isPresented: $isCustomAppViewVisible) {
    //                        NavigationStack {
    //                            CustomAppView()
    //                        }
    //                    }
    //                    .fullScreenCover(isPresented: $presentSubscriptionViewForCustom) {
    //                        SubscriptionView()
    //                    }
    //                }
    //                .padding(.bottom, 40)
               }
               if showLimitCrossed {
                   ToastView(message: "Maximum of \(cardsLimit) favourite app list can be added")
               }
           }
           .toolbar {
               ToolbarItem(placement: .navigationBarLeading) {
                   Text("Less Phone")
               }
               
               ToolbarItem(placement: .navigationBarTrailing) {
                   Button(action: {
                       Settings()
                   }) {
                       Image("SettingsNew")
                   }
               }
           }
    //        .background(Color.black)
    //        .foregroundColor(.white)
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
       let initialFavApps = UserDefaults.standard.value(forKey: UserDefaultsKeys.initallySelectedFavApps.rawValue) as? [String] ?? []
       if !initialFavApps.isEmpty {
           let convertedDictionary = initialFavApps.map { appName in
               guard let appIndex = viewModel.appList.firstIndex(where: { app in
                   app.appName == appName
               }) else {
                   return [String: String]()
               }
               let app = viewModel.appList[appIndex]
               return ["name": app.appName, "link": app.appLink, "rank": "\(app.appRank)"]
           }
           viewModel.setInitialFavApps(initalFavApps: convertedDictionary)
       }
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
                   VStack {
                       // show the app list in every card // farjum
                       
                       // left -> leading, center
                       // right -> trailing, center
                       // center -> center, center
                       // top -> center, top
                       // bottom  -> center, bottom


                       
                       ForEach(viewModel.appsOnAddView[index], id: \.self) { app in
                           Text(app)
                               .font(.title3)
                               .font(.system(size: 16 , weight: .medium))
                               .frame(maxWidth: .infinity, alignment: frameAlignment)
                               .listRowBackground(Color.clear)
                               .listRowInsets(EdgeInsets())
                               .listRowSeparator(.hidden)
                               .background(Color(hex: widgetVM.favAppWidgetConfig.backgroundColor))
                               .fontDesign(CustomWidget.FontTypeConverter(FontString: widgetVM.favAppWidgetConfig.fontType).value)
                               //.font(Font.custom( widgetVM.favAppWidgetConfig.fontType, size: 30))
                           //favAppWidgetConfig
                       }
                       .onMove { indices, newOffset in
                           moveItems(at: indices, to: newOffset, in: index)
                       }
                   }
                   .listStyle(.plain)
                   .padding(15)
                   .foregroundColor(Color(hex: widgetVM.favAppWidgetConfig.fontColor))
                   .scrollContentBackground(.hidden)
                   .fontWeight(CustomWidget.FontWeightConverter(weightString: widgetVM.favAppWidgetConfig.fontWeight).value)
                   .frame(
                       maxWidth: .infinity,
                       maxHeight: .infinity,
                       alignment: frameAlignment
                   )
                   
               }
           }
           .background(index == viewModel.cards ? Color.clear : Color(hex: widgetVM.favAppWidgetConfig.backgroundColor))
           .font(Font.custom( widgetVM.favAppWidgetConfig.fontType, size: 50))
           .frame(width: geo.size.width * 0.9, height: geo.size.height * 0.45)
           .background(index == viewModel.cards ? Color.gray.opacity(0.3) : Color.clear)
           .clipShape(RoundedRectangle(cornerRadius: 30))
           .overlay(
               RoundedRectangle(cornerRadius: 30).stroke(.white, lineWidth: 1)
           )
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
                       viewModel.setFavOnDeleteCard(cardIndex: index)
                   }
           }
       }
   }

   // MARK: - Helper Method
   private func moveItems(at indices: IndexSet, to newOffset: Int, in index: Int) {
       guard index < viewModel.appsOnAddView.count else { return }
       viewModel.appsOnAddView[index].move(fromOffsets: indices, toOffset: newOffset)
       viewModel.setFavAppsOnReorder(index: index)
   }

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
   AddView()
}
