//
//  HomeViewModel.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import Foundation

class HomeViewModel {
    
    let app: App
    let homeContainerViewModel: HomeContainerViewModel
    init(app: App, homeContainerViewModel: HomeContainerViewModel) {
        self.app = app
        self.homeContainerViewModel = homeContainerViewModel
    }
    
    func currencyString(from double: Double) -> String {
        String(format: "%.2f", double)
    }
    
    func usdString() -> String {
        let valueString = currencyString(from: app.bank.usd)
        return "$\(valueString)"
    }
    
    func btcString() -> String {
        let valueString = currencyString(from: app.bank.btc)
        return "B\(valueString)"
    }
    
    func ethString() -> String {
        let valueString = currencyString(from: app.bank.eth)
        return "E\(valueString)"
    }
    
}
