//
//  App.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import Foundation
import Combine

class App {
    
    var email: String = ""
    
    var firstName: String = ""
    var lastName: String = ""
    
    let updatePublisher = PassthroughSubject<Void, Never>()
    let balanceChangedPublisher = PassthroughSubject<Void, Never>()
    
    let sink = Sink()
    var bank = Bank()
    
    init() {
        Task {
            await sink.loadPersistentStores()
            
            let firstName = try? await sink.fetchFirstName()
            let lastName = try? await sink.fetchLastName()
            
            let balances = try? await sink.fetchBalances()
            
            await MainActor.run {
                
                if let name = firstName {
                    self.firstName = name
                }
                if let name = lastName {
                    self.lastName = name
                }
                
                if let balances = balances {
                    bank.usd = balances.usd
                    bank.btc = balances.btc
                    bank.eth = balances.eth
                }
                
                updatePublisher.send()
            }
        }
    }
    
    func save(username: String?) {
        if let username = username {
            Task {
                do {
                    try await sink.save(username: username)
                    
                } catch let error {
                    print("save username task error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func save(forUsername username: String?, password: String?) {
        if let username = username {
            if let password = password {
                do {
                    try Keychain.saveData(dataString: password, forAccount: username)
                } catch let error {
                    print("save password error: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func buy100BTC() {
        print("buy100BTC()")
        _ = bank.buyBTC(count: 100)
        saveBalances()
    }
    
    func buy100ETH() {
        print("buy100ETH()")
        _ = bank.buyETH(count: 100)
        saveBalances()
    }
    
    func sell10BTC() {
        print("sell10BTC()")
        _ = bank.sellBTC(count: 10)
        saveBalances()
    }
    
    func sell10ETH() {
        print("sell10ETH()")
        _ = bank.sellETH(count: 10)
        saveBalances()
    }
    
    func send10BTC() {
        print("send10BTC()")
        _ = bank.sendBTC(count: 10)
        saveBalances()
    }
    
    func send10ETH() {
        print("send10ETH()")
        _ = bank.sendETH(count: 10)
        saveBalances()
    }
    
    private func saveBalances() {
        Task {
            do {
                try await sink.save(usd: bank.usd,
                                    btc: bank.btc,
                                    eth: bank.eth)
            } catch let error {
                print("Error Saving Balances: \(error.localizedDescription)")
            }
        }
        
    }
    
}
