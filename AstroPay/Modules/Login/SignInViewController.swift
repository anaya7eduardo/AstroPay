//
//  ViewController.swift
//  AstroPay
//
//  Created by Eduardo Reyes on 2/24/23.
//

import UIKit
import Combine

class SignInViewController: UIViewController {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    @IBOutlet weak var languageSegment: UISegmentedControl!
    
    var viewModel: SignInViewModel! = nil
    
    func setup(viewModel: SignInViewModel) {
        self.viewModel = viewModel
    }
    
    private var cancelBag = Set<AnyCancellable>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        reloadLanguage()
        
        passwordTextField.isSecureTextEntry = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(receive(notification:)),
                                               name: Localizer.updateNotificationName,
                                               object: nil)
        
        viewModel.app.updatePublisher
            .receive(on: OperationQueue.main)
            .sink { _ in
                
                Task {
                    do {
                        let username = try await self.viewModel.app.sink.fetchUsername()
                        await MainActor.run {
                            self.usernameTextField.text = username
                            if let username = username {
                                do {
                                    self.passwordTextField.text = try Keychain.loadData(forAccount: username)
                                } catch let error {
                                    print("Keychain Load Error: \(error.localizedDescription)")
                                }
                            }
                        }
                    } catch let error {
                        print("Error: \(error.localizedDescription)")
                    }
                }
            }
            .store(in: &cancelBag)
    }
    
    @objc func receive(notification: Notification) {
        reloadLanguage()
    }
    
    func reloadLanguage() {
        usernameTextField.placeholder = Localizer.shared.text(key: "username")
        passwordTextField.placeholder = Localizer.shared.text(key: "password")
        
        signInButton.setTitle(Localizer.shared.text(key: "sign_in"), for: .normal)
        signUpButton.setTitle(Localizer.shared.text(key: "sign_up"), for: .normal)
        
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
    
    @IBAction func signInAction(_ sender: Any) {
        guard let text = usernameTextField.text else {
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
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        viewModel.app.save(username: username)
        viewModel.app.save(forUsername: username, password: password)
        
        viewModel.app.email = usernameTextField.text ?? "unknown@aol.com"
        
        let homeContainerViewModel = HomeContainerViewModel(app: viewModel.app)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let homeContainerViewController = storyboard.instantiateViewController(withIdentifier: "home_container") as? HomeContainerViewController else {
            return
        }
        
        homeContainerViewController.setup(viewModel: homeContainerViewModel)
        
        navigationController?.pushViewController(homeContainerViewController, animated: true)
    }
    
    @IBAction func signUpAction(_ sender: Any) {
        let registrationViewModel = RegistrationViewModel(app: viewModel.app)
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        guard let registrationNavigationController = storyboard.instantiateViewController(withIdentifier: "registration_navigation") as? UINavigationController else {
            return
        }
        
        registrationNavigationController.loadViewIfNeeded()
        
        if let registrationEmailViewController = registrationNavigationController.viewControllers.first as? RegistrationEmailViewController {
            registrationEmailViewController.setup(viewModel: registrationViewModel)
        }
        
        registrationNavigationController.isModalInPresentation = true
        
        present(registrationNavigationController, animated: true)
        
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
    
}
