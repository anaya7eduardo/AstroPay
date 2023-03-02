//
//  ProfileViewController.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/28/23.
//

import UIKit
import Combine

class ProfileViewController: UIViewController {

    @IBOutlet weak var nameTitleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var emailTitleLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var containerView: UIView!
    
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    var viewModel: ProfileViewModel! = nil
    
    func setup(viewModel: ProfileViewModel) {
        self.viewModel = viewModel
    }
    
    private var cancelBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.'
        
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
        
        viewModel.app.updatePublisher
            .receive(on: OperationQueue.main)
            .sink { _ in
                self.nameLabel.text = self.viewModel.fullName
            }
            .store(in: &cancelBag)
        
        emailLabel.text = viewModel.app.email
        nameLabel.text = viewModel.fullName
    }
    
    @objc func receive(notification: Notification) {
        reloadLanguage()
    }

    func reloadLanguage() {
        nameTitleLabel.text = Localizer.shared.text(key: "name")
        emailTitleLabel.text = Localizer.shared.text(key: "email")
        
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
