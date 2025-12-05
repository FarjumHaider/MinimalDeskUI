 

import SwiftUI
import Siren

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
    @State private var presentSubscriptionViewForCustom = false
    private let cardsLimit: Int = 5 // TODO: Change later

    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(spacing: 0) {
                Text("Less Phone")
                    .font(.largeTitle)
                    .bold()
                Spacer()

                // MARK: - AppList Widget Demo
                VStack {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 0) {
                            ForEach(0...viewModel.cards, id: \.self) { index in
                                CardView(for: index)
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
                        .padding(.leading, viewModel.cards <= 1 ? (screenWidth * 0.30) / 2.0 : 0)
                    }
                    .ignoresSafeArea()
                    .scrollTargetLayout()
                    .scrollBounceBehavior(.basedOnSize)
                    .scrollTargetBehavior(.viewAligned)
                    .scrollPosition(id: $currentCardIndex)
                }

                HStack(spacing: 0) {
                    Spacer()
                    addCardButton()
                }
                .frame(maxWidth: screenWidth * 0.9)

                if !showRatingView { Spacer() }

                // MARK: - Rating View
                if showRatingView {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("We appreciate your feedback!")
                            Text("Leave a 5-star rating for LessPhone on the App Store.")
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                        }
                        .font(.system(size: 14))
                        Spacer()
                        Text("Rate Now")
                            .font(.system(size: 14))
                            .foregroundColor(.green)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                requestReview()
                                showRatingView = false
                            }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical)
                    .padding(.horizontal, 10)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .overlay {
                        RoundedRectangle(cornerRadius: 10.0).stroke(.white, lineWidth: 1)
                    }
                    .padding()
                }

                // MARK: - Add Options
                HStack(spacing: gap) {
                    // MARK: - Add Apps from Given List
                    VStack(spacing: 8) {
                        Image("leftThumb")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                        Text("Add Apps")
                            .font(.headline)
                            .foregroundColor(Color.white)
                        Text("Add remove or reorder apps")
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 175.0/255, green: 175.0/255, blue: 179.0/255))
                    }
                    .frame(width: widthToSet, height: heightToSet)
                    .background(Color(red: 41/255, green: 44/255, blue: 53/255))
                    .cornerRadius(10)
                    .onTapGesture {
                        self.isDetailViewVisible.toggle()
                    }
                    .fullScreenCover(isPresented: $isDetailViewVisible) {
                        AppListView(viewModel: FirebaseDataViewModel.shared)
                    }

                    // MARK: - Add Custom Apps (with purchase restriction)
                    VStack(spacing: 8) {
                        Image("RightThumb")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 35, height: 35)
                        Text("Add Custom")
                            .font(.headline)
                            .foregroundColor(Color.white)
                        Text("Add apps by using URL Schemes")
                            .font(.system(size: 10))
                            .foregroundColor(Color(red: 175.0/255, green: 175.0/255, blue: 179.0/255))
                    }
                    .frame(width: widthToSet, height: heightToSet)
                    .background(Color(red: 41/255, green: 44/255, blue: 53/255))
                    .cornerRadius(10)
                    .onTapGesture {
                        Task {
                            await subViewModel.updateCustomerProductStatus()
                            await MainActor.run {
                                self.getValue()
                                if subscribed {
                                    isCustomAppViewVisible = true
                                } else {
                                    presentSubscriptionViewForCustom = true
                                }
                            }
                        }
                    }
                    .fullScreenCover(isPresented: $isCustomAppViewVisible) {
                        NavigationStack {
                            CustomAppView()
                        }
                    }
                    .fullScreenCover(isPresented: $presentSubscriptionViewForCustom) {
                        SubscriptionView()
                    }
                }
                .padding(.bottom, 40)
            }
            if showLimitCrossed {
                ToastView(message: "Maximum of \(cardsLimit) favourite app list can be added")
            }
        }
        .background(Color.black)
        .foregroundColor(.white)
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
        }
        .fullScreenCover(isPresented: $presentSubscriptionView) {
            SubscriptionView()
        }
        .fullScreenCover(isPresented: $showAppListView) {
            AppListView(viewModel: FirebaseDataViewModel.shared, cardIndex: currentCardIndex ?? 0)
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

    private func CardView(for index: Int) -> some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(alignment: .leading, spacing: 0) {
                if index == viewModel.cards {
                    Image(systemName: "plus")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.white)
                } else {
                    List {
                        ForEach(viewModel.appsOnAddView[index], id: \.self) { app in
                            Text(app)
                                .font(.title3)
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .listRowBackground(Color.clear)
                                .listRowInsets(EdgeInsets())
                                .listRowSeparator(.hidden)
                                .background(Color.black)
                        }
                        .onMove { indices, newOffset in
                            moveItems(at: indices, to: newOffset, in: index)
                        }
                    }
                    .listStyle(.plain)
                    .padding(15)
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .background(Color.black)
                }
            }
            .frame(width: screenWidth * 0.65, height: screenHeight * 0.30)
            .background(index == viewModel.cards ? Color.gray.opacity(0.3) : Color.clear)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10).stroke(.white, lineWidth: 1)
            )
            .padding()
            if index < viewModel.cards {
                Image(systemName: "trash.circle")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(.white)
                    .padding(25)
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
