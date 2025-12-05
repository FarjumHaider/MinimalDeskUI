import SwiftUI
import StoreKit

struct SubscriptionView: View {
    @AppStorage("subscribed") private var subscribed: Bool = false
    @Environment(\.dismiss) var dismiss
    @State private var selectedPlan = PlanType.yearly.rawValue
    @State private var shouldShowProgressView = false
    @ObservedObject private var store: Store = Store.shared
    @State private var isLoading = false
    @State private var errorMessage: String?
    @State private var isSubscribed = false
    @State private var showRestoreAlert = false
    @State private var restoreMessage = ""
    
    @State private var safariURL: URL?
    @State private var showSafari = false
    
    var body: some View {
        ScrollView {
            ZStack {
                VStack {
                    headerSection
                    
                    Text("Get Premium")
                        .font(.title)
                        .bold()
                        .padding(.bottom)
                    
                    featuresList
                    
                    planSelectionSection
                    
                    purchaseButton
                    
                    if let errorMessage = errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .font(.caption)
                            .padding(.top, 8)
                    }
                    
                    Spacer()
                    
                    footerSection
                        .padding(.bottom, 30)
                }
                
                if shouldShowProgressView || store.isRestoring {
                    LoadingOverlay(
                        isRestoring: store.isRestoring
                    )
                }
            }
            .sheet(isPresented: $showSafari) {
                if let url = safariURL {
                    SafariView(url: url)
                }
            }
            .alert("Restore Purchase", isPresented: $showRestoreAlert) {
                Button("OK") {}
            } message: {
                Text(restoreMessage)
            }
        }
        .foregroundStyle(.black)
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
        .task {
            await loadInitialData()
        }
        .onChange(of: store.purchasedLifetime) { _ in
            updateSubscriptionStatus()
        }
        .onChange(of: store.purchasedSubscriptions) { _ in
            updateSubscriptionStatus()
        }
    }
    
    // MARK: - View Components
    
    private var headerSection: some View {
        GeometryReader { geometry in
            ZStack {
                Image(.subscriptionBG)
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: 300)
                    .clipped()
                
                VStack(spacing: 0) {
                    HStack {
                        Button(action: {
                            dismiss()
                        }) {
                            ZStack {
                                Circle()
                                    .fill(Color.black.opacity(0.4))
                                    .frame(width: 40, height: 40)
                                
                                Image(systemName: "xmark")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundColor(.white)
                            }
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            Task {
                                await handleRestore()
                            }
                        }) {
                            HStack(spacing: 6) {
                                if store.isRestoring {
                                    ProgressView()
                                        .scaleEffect(0.7)
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                }
                                Text("Restore")
                                    .font(.system(size: 16, weight: .medium))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(20)
                        }
                        .disabled(store.isRestoring || isLoading)
                        .opacity((store.isRestoring || isLoading) ? 0.6 : 1.0)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, geometry.safeAreaInsets.top + 50)
                    
                    Spacer()
                    
                    VStack(spacing: 12) {
                        Text("LessPhone Pro")
                            .font(.system(size: 36, weight: .bold, design: .default))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                        
                        Text("Break free from digital overlord.")
                            .font(.system(size: 18, weight: .regular))
                            .foregroundColor(.white.opacity(0.95))
                            .multilineTextAlignment(.center)
                    }
                    .padding(.horizontal, 20)
                    
                    Spacer()
                        .frame(height: 30)
                }
            }
        }
        .frame(height: 300)
        .ignoresSafeArea(edges: .top)
    }
    
    private var featuresList: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("All Widget Access", systemImage: "checkmark.circle.fill")
            Label("Multiple Widget Setup", systemImage: "checkmark.circle.fill")
            Label("Control Digital Distractions", systemImage: "checkmark.circle.fill")
            Label("Ability to add apps independently", systemImage: "checkmark.circle.fill")
            Label("Lifetime Support", systemImage: "checkmark.circle.fill")
            Label("Ad-free Experience", systemImage: "checkmark.circle.fill")
        }
        .font(.system(size: 16))
        .padding([.leading, .bottom])
    }
    
    private var planSelectionSection: some View {
        VStack {
            monthlyPlanView
            yearlyPlanView
            lifetimePlanView
        }
        .padding()
        .frame(maxWidth: 320)
    }
    
    @ViewBuilder
    private var monthlyPlanView: some View {
        if let monthlyProduct = store.subscriptions.first(where: { $0.id == "lessphone.subscription.monthly" }) {
            planButtonWithProduct(
                title: "\(monthlyProduct.displayPrice) / Month",
                plan: .monthly,
                product: monthlyProduct
            )
        } else {
            planButtonFallback(
                title: "$2.99 / Month",
                plan: .monthly
            )
        }
    }
    
    @ViewBuilder
    private var yearlyPlanView: some View {
        if let yearlyProduct = store.subscriptions.first(where: { $0.id == "lessphone.subscription.yearly" }) {
            planButtonWithProduct(
                title: "\(yearlyProduct.displayPrice) / Year",
                plan: .yearly,
                imageName: "yearlySubscription",
                product: yearlyProduct
            )
        } else {
            planButtonFallback(
                title: "$9.99 / Year",
                plan: .yearly,
                imageName: "yearlySubscription"
            )
        }
    }
    
    @ViewBuilder
    private var lifetimePlanView: some View {
        if let lifetimeProduct = store.lifetime.first(where: { $0.id == "lessphone.lifetime.unlock" }) {
            planButtonWithProduct(
                title: "\(lifetimeProduct.displayPrice) / Lifetime",
                subtitle: "One-time Payment",
                plan: .lifetime,
                product: lifetimeProduct
            )
        } else {
            planButtonFallback(
                title: "$14.99 / Lifetime",
                subtitle: "One-time Payment",
                plan: .lifetime
            )
        }
    }
    
    private var purchaseButton: some View {
        Button {
            if !isSubscribed && !isLoading {
                Task {
                    await handlePurchase()
                }
            }
        } label: {
            HStack {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                        .scaleEffect(0.8)
                }
                
                Text(buttonTitle)
                    .font(.title2)
            }
            .frame(minWidth: 300)
            .padding(.vertical, 12)
            .background(buttonBackgroundColor)
            .clipShape(Capsule())
            .foregroundColor(.white)
        }
        .disabled(isSubscribed || isLoading || selectedProduct == nil)
    }
    
    private var footerSection: some View {
        VStack {
            if PlanType(rawValue: selectedPlan) == .lifetime {
                Text("One time Payment")
                    .font(.caption)
            } else {
                Text("Subscription is auto renewable. Cancel anytime.")
                    .font(.caption)
            }
            
            HStack(spacing: 20) {
                Text("Privacy Policy")
                    .underline()
                    .onTapGesture {
                        safariURL = URL(string: "https://sites.google.com/view/lessphone/home")
                        showSafari = true
                    }
                
                Text("Terms of Use")
                    .underline()
                    .onTapGesture {
                        safariURL = URL(string: "https://sites.google.com/view/terms-lessphone/home")
                        showSafari = true
                    }
                
                Text("Info")
                    .underline()
                    .onTapGesture {
                        safariURL = URL(string: "https://sites.google.com/view/subscription-info/home")
                        showSafari = true
                    }
            }
            .font(.caption2)
        }
        .padding(.top, 0)
    }
    
    private var selectedProduct: Product? {
        if let planType = PlanType(rawValue: selectedPlan) {
            switch planType {
            case .monthly:
                return store.subscriptions.first { $0.id == "lessphone.subscription.monthly" }
            case .yearly:
                return store.subscriptions.first { $0.id == "lessphone.subscription.yearly" }
            case .lifetime:
                return store.lifetime.first { $0.id == "lessphone.lifetime.unlock" }
            }
        }
        return nil
    }
    
    private var buttonTitle: String {
        if isLoading {
            return "Processing..."
        } else if isSubscribed {
            return "Purchased"
        } else {
            return "Continue"
        }
    }
    
    private var buttonBackgroundColor: Color {
        if isSubscribed {
            return Color.gray
        } else if selectedProduct == nil || isLoading {
            return Color.gray.opacity(0.6)
        } else {
            return Color.blue
        }
    }
    
    @MainActor
    private func loadInitialData() async {
        isLoading = true
        
        if store.subscriptions.isEmpty && store.lifetime.isEmpty {
            await store.requestProducts()
        }
        
        await store.updateCustomerProductStatus()
        updateSubscriptionStatus()
        
        selectedPlan = PlanType.yearly.rawValue
        
        isLoading = false
    }
    
    private func updateSubscriptionStatus() {
        isSubscribed = store.userHasActivePurchase()
        subscribed = isSubscribed
        
        if isSubscribed {
            errorMessage = nil
        }
    }
    
    @MainActor
    private func handleRestore() async {
        errorMessage = nil
        
        do {
            try await store.restorePurchases()
            
            if store.userHasActivePurchase() {
                restoreMessage = "Your purchases have been successfully restored. Thank you for your continued support."
                updateSubscriptionStatus()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    if self.isSubscribed {
                        self.dismiss()
                    }
                }
            } else {
                restoreMessage = "No previous purchases were found associated with this Apple ID. If you believe this is an error, please contact our support team."
            }
            
        } catch StoreError.restoreFailed {
            restoreMessage = "We encountered an issue while restoring your purchases. Please ensure you have a stable internet connection and try again."
        } catch {
            print("Restore error: \(error)")
            restoreMessage = "We encountered an issue while restoring your purchases. Please try again."
        }
        
        showRestoreAlert = true
    }
    
    @MainActor
    private func handlePurchase() async {
        guard let product = selectedProduct else {
            errorMessage = "Please select a plan."
            return
        }
        
        errorMessage = nil
        isLoading = true
        shouldShowProgressView = true
        
        do {
            let transaction = try await store.purchase(product)
            
            if transaction != nil {
                updateSubscriptionStatus()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    self.dismiss()
                }
            }
            
        } catch StoreError.failedVerification {
            errorMessage = "Purchase verification failed. Please try again."
        } catch StoreError.systemError {
            print("User cancelled purchase")
        } catch {
            print("Purchase error: \(error)")
            errorMessage = "Purchase failed. Please try again."
        }
        
        isLoading = false
        shouldShowProgressView = false
    }
    
    func planButtonWithProduct(
        title: String,
        subtitle: String? = nil,
        plan: PlanType,
        imageName: String? = nil,
        product: Product
    ) -> some View {
        createPlanButton(
            title: title,
            subtitle: subtitle,
            plan: plan,
            imageName: imageName
        )
    }
    
    func planButtonFallback(
        title: String,
        subtitle: String? = nil,
        plan: PlanType,
        imageName: String? = nil
    ) -> some View {
        createPlanButton(
            title: title,
            subtitle: subtitle,
            plan: plan,
            imageName: imageName
        )
    }
    
    private func createPlanButton(
        title: String,
        subtitle: String? = nil,
        plan: PlanType,
        imageName: String? = nil
    ) -> some View {
        HStack {
            if selectedPlan == plan.rawValue {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.blue)
                    .background(.clear)
                    .clipShape(Circle())
                    .padding(.leading)
            } else {
                Circle()
                    .stroke(style: StrokeStyle(lineWidth: 3))
                    .frame(width: 20)
                    .foregroundColor(.blue)
                    .padding(.leading)
            }
            
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(.system(size: 20, weight: .bold))
                if let subtitle = subtitle {
                    Text(subtitle)
                        .font(.system(size: 12))
                }
            }
            .padding(.vertical, 5)
            .padding(.leading)
            
            Spacer()
            
            if let imageName = imageName {
                Image(imageName)
                    .frame(width: 45, height: 45)
                    .padding(.trailing)
            }
        }
        .clipShape(Capsule())
        .overlay {
            Capsule().stroke(.blue, lineWidth: 3)
        }
        .onTapGesture {
            selectedPlan = plan.rawValue
        }
    }
}

struct LoadingOverlay: View {
    let isRestoring: Bool
    
    var body: some View {
        ZStack {
            Color.black
                .opacity(0.8)
                .ignoresSafeArea()
                .blur(radius: 3.0)

            VStack(spacing: 16) {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
                    .tint(.white)
                    .scaleEffect(2)

                Text(isRestoring ? "Restoring Purchases..." : "Processing...")
                    .foregroundColor(.white)
                    .font(.headline)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    SubscriptionView()
}
