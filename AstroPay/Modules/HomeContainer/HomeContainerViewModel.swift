//
//  HomeContainerViewModel.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import Foundation

class HomeContainerViewModel {
    
    let app: App
    init(app: App) {
        self.app = app
    }
    
    lazy var profileViewModel: ProfileViewModel = {
        ProfileViewModel(app: app, homeContainerViewModel: self)
    }()
    
    lazy var homeViewModel: HomeViewModel = {
        HomeViewModel(app: app, homeContainerViewModel: self)
    }()
    
    lazy var cryptoViewModel: CryptoViewModel = {
        CryptoViewModel(app: app, homeContainerViewModel: self)
    }()
    
}
