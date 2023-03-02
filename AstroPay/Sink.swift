//
//  Sink.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import Foundation
import CoreData

struct Balances {
    let usd: Double
    let btc: Double
    let eth: Double
}

class Sink {
    
    let container: NSPersistentContainer
    
    public required init() {
        container = NSPersistentContainer(name: "Database")
    }
    
    func loadPersistentStores() async {
        await withCheckedContinuation { continuation in
            container.loadPersistentStores { description, error in
                if let error = error {
                    print("Load Persistent Stores Error: \(error.localizedDescription)")
                }
                continuation.resume()
            }
        }
    }
    
    func save(username: String) async throws {
        let context = container.viewContext
        try await context.perform {
            let fetchRequest = Storage.fetchRequest()
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.username = Crypt.encrypt(string: username)
            } else {
                let user = Storage(context: context)
                user.username = Crypt.encrypt(string: username)
            }
            try context.save()
        }
    }
    
    func fetchUsername() async throws -> String? {
        let context = container.viewContext
        var results = [Storage]()
        try await context.perform {
            let fetchRequest = Storage.fetchRequest()
            results = try context.fetch(fetchRequest)
        }
        
        if let first = results.first {
            if let result = first.username {
                return Crypt.decrypt(string: result)
            }
        }
        return nil
    }
    
    func save(firstName: String) async throws {
        let context = container.viewContext
        try await context.perform {
            let fetchRequest = Storage.fetchRequest()
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.first_name = firstName
            } else {
                let user = Storage(context: context)
                user.first_name = firstName
            }
            try context.save()
        }
    }
    
    func fetchFirstName() async throws -> String? {
        let context = container.viewContext
        var results = [Storage]()
        try await context.perform {
            let fetchRequest = Storage.fetchRequest()
            results = try context.fetch(fetchRequest)
        }
        
        if let first = results.first {
            if let result = first.first_name {
                return result
            }
        }
        return nil
    }
    
    func save(lastName: String) async throws {
        let context = container.viewContext
        try await context.perform {
            let fetchRequest = Storage.fetchRequest()
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.last_name = lastName
            } else {
                let user = Storage(context: context)
                user.last_name = lastName
            }
            try context.save()
        }
    }
    
    public func fetchLastName() async throws -> String? {
        let context = container.viewContext
        var results = [Storage]()
        try await context.perform {
            let fetchRequest = Storage.fetchRequest()
            results = try context.fetch(fetchRequest)
        }
        
        if let first = results.first {
            if let result = first.last_name {
                return result
            }
        }
        return nil
    }
    
    func save(usd: Double, btc: Double, eth: Double) async throws {
        let context = container.viewContext
        try await context.perform {
            let fetchRequest = Storage.fetchRequest()
            let users = try context.fetch(fetchRequest)
            if let user = users.first {
                user.usd = usd
                user.btc = btc
                user.eth = eth
                user.did_save_balances = true
                
            } else {
                let user = Storage(context: context)
                user.usd = usd
                user.btc = btc
                user.eth = eth
                user.did_save_balances = true
            }
            try context.save()
        }
    }
    
    func fetchBalances() async throws -> Balances? {
        let context = container.viewContext
        var results = [Storage]()
        try await context.perform {
            let fetchRequest = Storage.fetchRequest()
            results = try context.fetch(fetchRequest)
        }
        
        if let first = results.first {
            if first.did_save_balances {
                let usd = first.usd
                let btc = first.btc
                let eth = first.eth
                
                return Balances(usd: usd, btc: btc, eth: eth)
            }
        }
        return nil
    }
    
}
