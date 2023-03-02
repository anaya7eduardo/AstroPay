//
//  Bank.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import Foundation

struct Bank {
    
    static let updateNotificationName = NSNotification.Name("bank.update")
    
    static let BTC_USD = 0.00035
    static let ETH_USD = 0.008525
    
    func btc(usd: Double) -> Double {
        usd * Self.BTC_USD
    }
    
    func usd(btc: Double) -> Double {
        btc * (1.0 / Self.BTC_USD)
    }
    
    func eth(usd: Double) -> Double {
        usd * Self.ETH_USD
    }
    
    func usd(eth: Double) -> Double {
        btc * (1.0 / Self.ETH_USD)
    }
    
    var usd: Double = 10000000.0
    var btc: Double = 100.0
    var eth: Double = 1000.0
    
    mutating func buyBTC(count: Int) -> Bool {
        let cost = usd(btc: Double(count))
        if usd >= cost {
            usd -= cost
            btc += Double(count)
            print("Bought \(count) BTC!!!")
            printBalances()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Self.updateNotificationName, object: nil)
            }
            return true
        }
        print("Could not buy \(count) BTC!!!")
        printBalances()
        return false
    }
    
    mutating func buyETH(count: Int) -> Bool {
        let cost = usd(eth: Double(count))
        if usd >= cost {
            usd -= cost
            eth += Double(count)
            print("Bought \(count) ETH!!!")
            printBalances()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Self.updateNotificationName, object: nil)
            }
            return true
        }
        print("Could not buy \(count) ETH!!!")
        printBalances()
        return false
    }
    
    mutating func sellBTC(count: Int) -> Bool {
        if btc >= Double(count) {
            usd += usd(btc: Double(count))
            btc -= Double(count)
            print("Sold \(count) BTC!!!")
            printBalances()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Self.updateNotificationName, object: nil)
            }
            return true
        }
        print("Could not sell \(count) BTC!!!")
        printBalances()
        return false
    }
    
    mutating func sellETH(count: Int) -> Bool {
        if eth >= Double(count) {
            usd += usd(eth: Double(count))
            eth -= Double(count)
            print("Sold \(count) ETH!!!")
            printBalances()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Self.updateNotificationName, object: nil)
            }
            return true
        }
        print("Could not sell \(count) ETH!!!")
        printBalances()
        return false
    }
    
    mutating func sendBTC(count: Int) -> Bool {
        if btc >= Double(count) {
            btc -= Double(count)
            print("Sent \(count) BTC!!!")
            printBalances()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Self.updateNotificationName, object: nil)
            }
            return true
        }
        print("Could not send \(count) BTC!!!")
        printBalances()
        return false
    }
    
    mutating func sendETH(count: Int) -> Bool {
        if eth >= Double(count) {
            eth -= Double(count)
            print("Sent \(count) ETH!!!")
            printBalances()
            DispatchQueue.main.async {
                NotificationCenter.default.post(name: Self.updateNotificationName, object: nil)
            }
            return true
        }
        print("Could not send \(count) ETH!!!")
        printBalances()
        return false
    }
    
    func printBalances() {
        print("==== Balances ====")
        print("USD: \(usd)")
        print("BTC: \(btc)")
        print("ETH: \(eth)")
    }
    
}
