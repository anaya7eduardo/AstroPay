//
//  RegistrationViewController.swift
//  AstroPay
//
//  Created by Nicky Taylor on 2/28/23.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    var viewModel: RegistrationViewModel! = nil
    func setup(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(receive(notification:)),
                                               name: Localizer.updateNotificationName,
                                               object: nil)
        

        reloadLanguage()
        
    }
    
    @objc func receive(notification: Notification) {
        reloadLanguage()
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
