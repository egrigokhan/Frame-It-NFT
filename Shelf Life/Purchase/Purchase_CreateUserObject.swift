//
//  Purchase_CreateUserObject.swift
//  Shelf Life
//
//  Created by Gokhan Egri on 28.06.2021.
//

import Foundation
import StoreKit

class Purchase_CreateUserObject: NSObject, SKPaymentTransactionObserver {
    
    let PurchaseID: String = "create_user_inventory"

    override init() {
        super.init()
        SKPaymentQueue.default().add(self)
    }
    
    func buy() {
        if SKPaymentQueue.canMakePayments() {
            let transactionRequest = SKMutablePayment()
            transactionRequest.productIdentifier = PurchaseID
            SKPaymentQueue.default().add(transactionRequest)
        } else {
            print("User can not make transaction.")
            // make alert
        }
    }
    
    func restorePurchases() {
        SKPaymentQueue.default().restoreCompletedTransactions()
    }
    
    func addTrials(count: Int = 3) {
        UserDefaults.standard.setValue(count, forKey: "purchase-trials:" + PurchaseID)
    }
    
    func decreaseTrials(by: Int = 1) {
        var purchaseTrials = UserDefaults.standard.integer(forKey: "purchase-trials:" + PurchaseID) - 1

        UserDefaults.standard.setValue((purchaseTrials < 0) ? 0 : purchaseTrials, forKey: "purchase-trials:" + PurchaseID)
    }
    
    
    func checkPurchaseBOOL() -> [String:Any] {
        let restoredPurchases = UserDefaults.standard.bool(forKey: "restored-purchases")
        let purchased = UserDefaults.standard.bool(forKey: "purchase:" + PurchaseID)
        let purchaseTrials = UserDefaults.standard.integer(forKey: "purchase-trials:" + PurchaseID)
        
        if(purchased) {
            return ["purchased": true, "trials": -99]
        } else {
            if(purchaseTrials > 0) {
                return ["purchased": false, "trials": purchaseTrials]
            }
            return ["purchased": false, "trials": 0]
        }
    }
    
    func checkPurchase(callback: () -> (), alertcallback: () -> ()) {
        let restoredPurchases = UserDefaults.standard.bool(forKey: "restored-purchases")
        let purchased = UserDefaults.standard.bool(forKey: "purchase:" + PurchaseID)
        let purchaseTrials = UserDefaults.standard.integer(forKey: "purchase-trials:" + PurchaseID)
        
        if(purchased) {
            callback()
        } else {
            alertcallback()
        }
    }
    
    func showPurchaseAlert() {
        
    }
}

extension Purchase_CreateUserObject {
    public func paymentQueue(_ queue: SKPaymentQueue,
                             updatedTransactions transactions: [SKPaymentTransaction]) {
      for transaction in transactions {
        switch transaction.transactionState {
        case .purchased:
          complete(transaction: transaction)
          break
        case .failed:
          fail(transaction: transaction)
          break
        case .restored:
          restore(transaction: transaction)
          break
        case .deferred:
          break
        case .purchasing:
          break
        }
      }
    }
   
    private func complete(transaction: SKPaymentTransaction) {
        print("Transaction is successful.")
        
        // make alert
        SKPaymentQueue.default().finishTransaction(transaction)
        
        UserDefaults.standard.set(true, forKey: "purchase:" + PurchaseID)
    }
   
    private func restore(transaction: SKPaymentTransaction) {
      guard let productIdentifier = transaction.original?.payment.productIdentifier else { return }
   
      print("restore... \(productIdentifier)")
      deliverPurchaseNotificationFor(identifier: productIdentifier)
      SKPaymentQueue.default().finishTransaction(transaction)
      UserDefaults.standard.set(true, forKey: "restored-purchases")
      UserDefaults.standard.set(true, forKey: "purchase:" + productIdentifier)
    }
   
    private func fail(transaction: SKPaymentTransaction) {
        print("Transaction has failed.")
        // make alert
        if let transactionError = transaction.error as NSError?,
        let localizedDescription = transaction.error?.localizedDescription,
          transactionError.code != SKError.paymentCancelled.rawValue {
          print("Transaction Error: \(localizedDescription)")
        }

        SKPaymentQueue.default().finishTransaction(transaction)
    }
   
    private func deliverPurchaseNotificationFor(identifier: String?) {
      guard let identifier = identifier else { return }
   
        // NotificationCenter.default.post(name: ., object: identifier)
    }
}
