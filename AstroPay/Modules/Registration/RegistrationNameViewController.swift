//
//  RegistrationPasswordViewController.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 3/1/23.
//

import UIKit

class RegistrationNameViewController: UIViewController {
    
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    @IBOutlet weak var doneButton: UIButton!
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    
    var viewModel: RegistrationViewModel! = nil
    func setup(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
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
        
        closeButton.title = Localizer.shared.text(key: "close")
        
        firstNameTextField.placeholder = Localizer.shared.text(key: "first_name")
        lastNameTextField.placeholder = Localizer.shared.text(key: "last_name")
        
        doneButton.setTitle(Localizer.shared.text(key: "done"), for: .normal)
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
    
    @IBAction func closeAction(_ sender: Any) {
        navigationController?.presentingViewController?.dismiss(animated: true)
    }
    
    @IBAction func doneAction(_ sender: Any) {
        if let firstName = firstNameTextField.text {
            if let lastName = lastNameTextField.text {
                
                viewModel.app.firstName = firstName
                viewModel.app.lastName = lastName
                
                Task {
                    do {
                        try await viewModel.app.sink.save(firstName: firstName)
                        try await viewModel.app.sink.save(lastName: lastName)
                        
                    } catch let error {
                        print("Error With Sink: \(error.localizedDescription)")
                    }
                    await MainActor.run {
                        viewModel.app.updatePublisher.send()
                    }
                }
            }
        }
        
        navigationController?.presentingViewController?.dismiss(animated: true)
    }
    
}
