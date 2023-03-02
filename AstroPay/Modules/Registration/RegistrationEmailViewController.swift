//
//  RegistrationEmailViewController.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 3/1/23.
//

import UIKit

class RegistrationEmailViewController: UIViewController {
    
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var closeButton: UIBarButtonItem!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
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
        
        emailTextField.placeholder = Localizer.shared.text(key: "email")
        passwordTextField.placeholder = Localizer.shared.text(key: "password")
        
        nextButton.setTitle(Localizer.shared.text(key: "next"), for: .normal)
        
        self.title = Localizer.shared.text(key: "registration")
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
    
    @IBAction func nextAction(_ sender: Any) {
        guard let text = emailTextField.text else {
            showBadEmailDialog()
            return
        }
        
        let validator = EmailValidator()
        guard validator.isValid(text) else {
            showBadEmailDialog()
            return
        }
        
        if passwordTextField.text!.count < 8 {
            showBadPasswordDialog()
        }
        
        if let email = emailTextField.text {
            viewModel.app.email = email
            Task {
                do {
                    try await viewModel.app.sink.save(username: email)
                } catch let error {
                    print("Error With Sink: \(error.localizedDescription)")
                }
                await MainActor.run {
                    viewModel.app.updatePublisher.send()
                }
            }
        }
        
        self.performSegue(withIdentifier: "name_page", sender: nil)
    }
    
    private func showBadEmailDialog() {
        let alert = UIAlertController(title: "Invalid E-Mail", message: "Please check your e-mail and try again!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    private func showBadPasswordDialog() {
        let alert = UIAlertController(title: "Invalid Password", message: "Min length 8 characters!", preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        
        self.present(alert, animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let registrationNameViewController = segue.destination as? RegistrationNameViewController {
            registrationNameViewController.setup(viewModel: viewModel)
        }
    }
    
}
