//
//  CryptoViewController.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import UIKit

class CryptoViewController: UIViewController {
    
    @IBOutlet weak var languageSegment: UISegmentedControl!
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var buttonBuy100BTC: UIButton!
    @IBOutlet weak var buttonSell10BTC: UIButton!
    @IBOutlet weak var buttonSend10BTC: UIButton!
    
    @IBOutlet weak var buttonBuy100ETH: UIButton!
    @IBOutlet weak var buttonSell10ETH: UIButton!
    @IBOutlet weak var buttonSend10ETH: UIButton!
    
    var viewModel: CryptoViewModel! = nil
    func setup(viewModel: CryptoViewModel) {
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
        
        NotificationCenter.default.addObserver(self, selector: #selector(receive(notification:)),
                                               name: Localizer.updateNotificationName,
                                               object: nil)
        
        reloadLanguage()
    }
    
    @objc func receive(notification: Notification) {
        reloadLanguage()
    }

    func reloadLanguage() {
        buttonBuy100BTC.setTitle(Localizer.shared.text(key: "buy_100_btc"), for: .normal)
        buttonSell10BTC.setTitle(Localizer.shared.text(key: "sell_10_btc"), for: .normal)
        buttonSend10BTC.setTitle(Localizer.shared.text(key: "send_10_btc"), for: .normal)
        
        buttonBuy100ETH.setTitle(Localizer.shared.text(key: "buy_100_eth"), for: .normal)
        buttonSell10ETH.setTitle(Localizer.shared.text(key: "sell_10_eth"), for: .normal)
        buttonSend10ETH.setTitle(Localizer.shared.text(key: "send_10_eth"), for: .normal)
        
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
    
    @IBAction func buy100BTCAction(_ sender: Any) {
        viewModel.app.buy100BTC()
    }
    
    @IBAction func sell10BTCAction(_ sender: Any) {
        viewModel.app.sell10BTC()
    }
    
    @IBAction func send10BTCAction(_ sender: Any) {
        viewModel.app.send10BTC()
    }
    
    @IBAction func buy100ETHAction(_ sender: Any) {
        viewModel.app.buy100ETH()
    }
    
    @IBAction func sell10ETHAction(_ sender: Any) {
        viewModel.app.sell10ETH()
    }
    
    @IBAction func send10ETHAction(_ sender: Any) {
        viewModel.app.send10ETH()
    }
    
}
