//
//  HomeViewController.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var labelUSD: UILabel!
    @IBOutlet weak var labelBTC: UILabel!
    @IBOutlet weak var labelETH: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    var viewModel: HomeViewModel! = nil
    func setup(viewModel: HomeViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        containerView.backgroundColor = UIColor(red: 0.9125,
                                                green: 0.9125,
                                                blue: 0.9125,
                                                alpha: 1.0)
        containerView.layer.cornerRadius = 12.0
        containerView.layer.borderColor = UIColor(red: 0.8125,
                                                  green: 0.8125,
                                                  blue: 0.8125,
                                                  alpha: 1.0).cgColor
        containerView.layer.borderWidth = 1.0
        
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.4).cgColor
        containerView.layer.shadowRadius = 2.0
        containerView.layer.shadowOffset = CGSize(width: -1.0,
                                                  height: 2.0)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveLocalization(notification:)),
                                               name: Localizer.updateNotificationName,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveBank(notification:)),
                                               name: Bank.updateNotificationName,
                                               object: nil)
        
        reloadLanguage()
        reloadBalances()
    }
    
    @objc func receiveLocalization(notification: Notification) {
        reloadLanguage()
    }
    
    @objc func receiveBank(notification: Notification) {
        reloadBalances()
    }
    
    func reloadBalances() {
        labelUSD.text = viewModel.usdString()
        labelBTC.text = viewModel.btcString()
        labelETH.text = viewModel.ethString()
    }
    
    func reloadLanguage() {
        let lang = Localizer.shared.currentLanguage
        switch lang {
        case .en:
            languageSegment.selectedSegmentIndex = 0
        case .fr:
            languageSegment.selectedSegmentIndex = 1
        }
    }
    
    @IBAction func changeLanguage(_ sender: Any) {
        if languageSegment.selectedSegmentIndex == 0 {
            Localizer.shared.set(language: .en)
            reloadLanguage()
        }
        
        if languageSegment.selectedSegmentIndex == 1 {
            Localizer.shared.set(language: .fr)
            reloadLanguage()
        }
    }
    
}
