//
//  Store.swift
//  MinimalDesk
//
//  Created by Rafsan Nazmul on 08/06/25.
//

import Foundation
import StoreKit

typealias Transaction = StoreKit.Transaction
typealias RenewalInfo = StoreKit.Product.SubscriptionInfo.RenewalInfo
typealias RenewalState = StoreKit.Product.SubscriptionInfo.RenewalState

public enum StoreError: Error {
    case failedVerification
    case productNotFound
    case restoreFailed
    case networkError
    case systemError
}

public enum SubscriptionTier: Int, Comparable {
    case none = 0
    case monthly = 1
    case yearly = 2
    
    public static func < (lhs: Self, rhs: Self) -> Bool {
        return lhs.rawValue < rhs.rawValue
    }
}

@MainActor
class Store: ObservableObject {
    @Published private(set) var lifetime: [Product] = []
    @Published private(set) var subscriptions: [Product] = []
    @Published private(set) var purchasedSubscriptions: [Product] = []
    @Published private(set) var purchasedLifetime: Bool = false
    @Published private(set) var subscriptionGroupStatus: RenewalState?
    @Published var isRestoring: Bool = false
    @Published var isLoading: Bool = false
    @Published var restoredProductIds: [String] = []
    
    private var updateListenerTask: Task<Void, Error>?
    private let productIds: Set<String>
    
    static let shared = Store()
    
    private init() {
        self.productIds = Set([
            "lessphone.subscription.monthly",
            "lessphone.subscription.yearly",
            "lessphone.lifetime.unlock"
        ])
        
        updateListenerTask = listenForTransactions()
        
        Task {
            await requestProducts()
            await updateCustomerProductStatus()
        }
    }
    
    deinit {
        updateListenerTask?.cancel()
    }
    
    private func listenForTransactions() -> Task<Void, Error> {
        return Task.detached { [weak self] in
            for await result in Transaction.updates {
                do {
                    let transaction = try await self?.checkVerified(result)
                    await self?.updateCustomerProductStatus()
                    await transaction?.finish()
                } catch {
                    print("❌ Transaction verification failed: \(error)")
                }
            }
        }
    }
    
    func requestProducts() async {
        do {
            isLoading = true
            let storeProducts = try await Product.products(for: productIds)
            
            var newLifetime: [Product] = []
            var newSubscriptions: [Product] = []
            
            for product in storeProducts {
                switch product.type {
                case .nonConsumable:
                    newLifetime.append(product)
                case .autoRenewable:
                    newSubscriptions.append(product)
                default:
                    print("Unknown product type: \(product.type)")
                }
            }
            
            lifetime = sortByPrice(newLifetime)
            subscriptions = sortByPrice(newSubscriptions)
            isLoading = false
            
        } catch {
            print("❌ Failed to load products: \(error)")
            isLoading = false
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            
            await updateCustomerProductStatus()
            
            await transaction.finish()
            
            return transaction
            
        case .userCancelled:
            throw StoreError.systemError
            
        case .pending:
            print("⏳ Purchase is pending approval")
            return nil
            
        @unknown default:
            throw StoreError.systemError
        }
    }
    
    func restorePurchases() async throws {
        guard !isRestoring else { return }
        
        isRestoring = true
        
        defer {
            isRestoring = false
        }
        
        do {
            try await AppStore.sync()
            
            await updateCustomerProductStatus()
            
            print("✅ Restore completed successfully")
            
        } catch {
            print("❌ Restore failed: \(error)")
            throw StoreError.restoreFailed
        }
    }
    
    func updateCustomerProductStatus() async {
        var activeSubscriptions: [Product] = []
        var hasLifetime = false
        var latestSubscriptionStatus: RenewalState?
        
        clearStoredPurchaseState()
        
        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)
                
                switch transaction.productType {
                case .nonConsumable:
                    hasLifetime = true
                    savePurchaseState(productId: transaction.productID, isLifetime: true)
                    print("✅ Found lifetime purchase: \(transaction.productID)")
                    
                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }),
                       let expirationDate = transaction.expirationDate {
                        
                        if expirationDate > Date() {
                            activeSubscriptions.append(subscription)
                            savePurchaseState(
                                productId: transaction.productID,
                                expirationDate: expirationDate
                            )
                            print("✅ Found active subscription: \(transaction.productID), expires: \(expirationDate)")
                        }
                    }
                    
                default:
                    break
                }
                
            } catch {
                print("❌ Failed to verify transaction: \(error)")
            }
        }
        
        self.purchasedLifetime = hasLifetime
        self.purchasedSubscriptions = activeSubscriptions
        
        do {
            if let firstSubscription = subscriptions.first {
                latestSubscriptionStatus = try await firstSubscription.subscription?.status.first?.state
            }
        } catch {
            print("⚠️ Could not fetch subscription group status: \(error)")
        }
        
        self.subscriptionGroupStatus = latestSubscriptionStatus
        
        print("📊 Status updated - Lifetime: \(hasLifetime), Active subs: \(activeSubscriptions.count)")
    }
    
    private func clearStoredPurchaseState() {
        UserDefaults.standard.removeObject(forKey: "subscriptionExpirationDate")
        UserDefaults.standard.removeObject(forKey: "hasActiveSubscription")
        UserDefaults.standard.removeObject(forKey: "lifetimePurchase")
    }
    
    private func savePurchaseState(productId: String, isLifetime: Bool = false, expirationDate: Date? = nil) {
        if isLifetime {
            UserDefaults.standard.set(true, forKey: "lifetimePurchase")
            UserDefaults.standard.set(true, forKey: "hasActiveSubscription")
            UserDefaults.standard.set(Date.distantFuture, forKey: "subscriptionExpirationDate")
        } else if let expirationDate = expirationDate {
            UserDefaults.standard.set(expirationDate, forKey: "subscriptionExpirationDate")
            UserDefaults.standard.set(true, forKey: "hasActiveSubscription")
        }
    }
    
    func userHasActivePurchase() -> Bool {
        purchasedLifetime = true
        if purchasedLifetime || UserDefaults.standard.bool(forKey: "lifetimePurchase") {
            return true
        }
        
        if !purchasedSubscriptions.isEmpty {
            return true
        }
        
        if let expirationDate = UserDefaults.standard.object(forKey: "subscriptionExpirationDate") as? Date {
            return expirationDate > Date()
        }
        
        return false
    }
    
    func isActiveSubscription() -> Bool {
        return userHasActivePurchase()
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    private func sortByPrice(_ products: [Product]) -> [Product] {
        products.sorted { $0.price < $1.price }
    }
    
    func tier(for productId: String) -> SubscriptionTier {
        switch productId {
        case "lessphone.subscription.monthly":
            return .monthly
        case "lessphone.subscription.yearly":
            return .yearly
        default:
            return .none
        }
    }
}
