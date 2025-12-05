import Foundation
import StoreKit

@MainActor
class SubscriptionViewModel: ObservableObject {
    // MARK: - Published Properties
    @Published var purchasedSubscriptions: [Product] = []
    @Published var purchasedLifetime: Bool = false
    @Published var subscriptionGroupStatus: Product.SubscriptionInfo.Status?  // Store whole Status, not just State enum

    // MARK: - Products (Inject or load externally)
    var subscriptions: [Product] = []

    // MARK: - Public Access Checker
    var hasValidPurchase: Bool {
        if let expirationDate = UserDefaults.standard.object(forKey: "subscriptionExpirationDate") as? Date {
            return expirationDate > Date()
        }
        return false
    }

    // MARK: - Update Customer Purchase Status
    func updateCustomerProductStatus() async {
        var activeSubscriptions: [Product] = []
        purchasedLifetime = false
        subscriptionGroupStatus = nil

        for await result in Transaction.currentEntitlements {
            do {
                let transaction = try checkVerified(result)

                switch transaction.productType {
                case .nonConsumable:
                    purchasedLifetime = true
                    UserDefaults.standard.set(Date.distantFuture, forKey: "subscriptionExpirationDate")
                    UserDefaults.standard.set(true, forKey: "hasActiveSubscription")

                   
                    print("✅ Lifetime purchase saved.")

                case .autoRenewable:
                    if let subscription = subscriptions.first(where: { $0.id == transaction.productID }),
                       let expirationDate = transaction.expirationDate {
                        if expirationDate > Date() {
                            activeSubscriptions.append(subscription)
                            UserDefaults.standard.set(expirationDate, forKey: "subscriptionExpirationDate")
                            print("✅ Subscription active until \(expirationDate)")
                        } else {
                            print("❌ Subscription expired.")
                            UserDefaults.standard.removeObject(forKey: "subscriptionExpirationDate")
                        }
                    }

                default:
                    break
                }

            } catch {
                print("❌ Failed to verify transaction: \(error)")
            }
        }

        self.purchasedSubscriptions = activeSubscriptions

        do {
            // Fetch subscription group status (requires network)
            self.subscriptionGroupStatus = try await subscriptions.first?.subscription?.status.first
        } catch {
            print("⚠️ Could not fetch subscription status: \(error.localizedDescription)")
        }
    }

    // MARK: - Helper to verify transaction
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw NSError(domain: "TransactionVerification", code: 401, userInfo: [NSLocalizedDescriptionKey: "Transaction unverified"])
        case .verified(let safe):
            return safe
        }
    }
}

