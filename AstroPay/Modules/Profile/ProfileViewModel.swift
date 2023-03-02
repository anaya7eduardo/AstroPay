//
//  ProfileViewModel.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import Foundation

class ProfileViewModel {
    
    let app: App
    let homeContainerViewModel: HomeContainerViewModel
    init(app: App, homeContainerViewModel: HomeContainerViewModel) {
        self.app = app
        self.homeContainerViewModel = homeContainerViewModel
    }
    
    var fullName: String {
        "\(app.firstName) \(app.lastName)"
    }
    
}
