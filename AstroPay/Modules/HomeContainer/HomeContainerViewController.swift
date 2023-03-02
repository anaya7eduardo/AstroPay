//
//  HomeContainerViewController.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import UIKit

class HomeContainerViewController: UITabBarController {
    
    var viewModel: HomeContainerViewModel! = nil
    func setup(viewModel: HomeContainerViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        print(viewControllers as Any)
        
        if let viewControllers = viewControllers {
            for viewController in viewControllers {
                if let profileViewController = viewController as? ProfileViewController {
                    // print("profileViewController = \(profileViewController)")
                    profileViewController.setup(viewModel: viewModel.profileViewModel)
                }
                if let homeViewController = viewController as? HomeViewController {
                    // print("homeViewController = \(homeViewController)")
                    homeViewController.setup(viewModel: viewModel.homeViewModel)
                }
                if let cryptoViewController = viewController as? CryptoViewController {
                    // print("cryptoViewController = \(cryptoViewController)")
                    cryptoViewController.setup(viewModel: viewModel.cryptoViewModel)
                }
                
            }
        }
    }
    
}
